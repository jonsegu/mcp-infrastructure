# MCP Documentation - Terraform Infrastructure

Infraestructura Terraform modular para `mcp-documentation` en Google Cloud Platform.

## Arquitectura

```text
User
|
v
Cloud Run WEB
|
+--> Vertex AI Gemini
|
v
Cloud Run MCP
|
v
GCS Bucket
```

- `Cloud Run WEB` (Next.js + API + cliente MCP) invoca al servicio MCP usando IAM.
- `Cloud Run MCP` accede documentación privada en GCS usando IAM.
- `Artifact Registry` almacena imágenes Docker para WEB y MCP.
- `Service Accounts` separadas con principio de mínimo privilegio.

## Estructura

```text
infra/
├── main.tf
├── versions.tf
├── variables.tf
├── outputs.tf
├── backend_dev.hcl
├── providers.tf
├── cloud_run_web.tf
├── cloud_run_mcp.tf
├── storage.tf
├── artifact_registry.tf
├── iam.tf
├── service_accounts.tf
├── apis.tf
├── envs/
│   └── terraform_prod.tfvars
└── modules/
    ├── cloud_run/
    ├── storage_bucket/
    ├── artifact_registry/
    ├── project_services/
  └── service_account/
```

## Prerrequisitos

- Terraform `>= 1.6.0`
- Cuenta con permisos para crear recursos en GCP
- Proyecto GCP existente
- Billing habilitado en el proyecto
- APIs habilitables por Terraform (módulo `project_services`)
- Imágenes Docker existentes en Artifact Registry antes del primer deploy de Cloud Run

## Backend remoto (GCS)

`versions.tf` define:

```hcl
backend "gcs" {}
```

La configuración concreta va en `backend_dev.hcl`.

Inicialización:

```bash
terraform init -backend-config=backend_dev.hcl
```

### Importante sobre bootstrap del bucket de state

El bucket de Terraform state **no puede crearse en esta misma configuración** cuando se usa para `terraform init`.
Debes crearlo previamente (bootstrap) fuera de este stack o con un stack separado.

## Variables y tfvars

- Todas las variables relevantes se definen en `variables.tf`.
- Valores de entorno `prod` en `envs/terraform_prod.tfvars`.
- No se incluyen secretos reales.
- No se usan JSON keys de service accounts.

Variables clave:
- Identidad/entorno: `project_id`, `project_name`, `environment`, `region`
- Naming y etiquetas: `labels`
- App: `allowed_emails`, `domain_name`, `gemini_model`, `google_cloud_location`, `llm_provider`
- Cloud Run: nombres, imágenes, CPU/memoria, escalado, puertos, ingress, timeout, concurrency
- Cloud Run: `cloud_run_deletion_protection`
- Storage/Artifact Registry: nombres lógicos y políticas
- Artifact cleanup: `artifact_keep_count`, `artifact_delete_older_than`
- APIs: `project_services`

## APIs habilitadas

Se habilitan desde `modules/project_services` con lista configurable, por ejemplo:

- `run.googleapis.com`
- `artifactregistry.googleapis.com`
- `storage.googleapis.com`
- `aiplatform.googleapis.com`
- `iam.googleapis.com`
- `iamcredentials.googleapis.com`
- `cloudresourcemanager.googleapis.com`
- `serviceusage.googleapis.com`

## IAM (mínimo privilegio)

- WEB SA:
  - `roles/aiplatform.user` en proyecto
  - `roles/run.invoker` sobre Cloud Run MCP
- MCP SA:
  - `roles/storage.objectViewer` sobre bucket de documentación
- MCP permanece privado (`allow_unauthenticated = false`)
- WEB público (`allow_unauthenticated = true`)

## Relación WEB ↔ MCP

- `cloud_run_mcp.tf` crea MCP primero.
- `cloud_run_web.tf` inyecta `MCP_SERVER_URL` usando output de MCP: `${module.documentation_mcp.uri}/mcp`.
- WEB invoca MCP autenticado mediante IAM (`roles/run.invoker` para WEB SA).
- El MCP se mantiene privado por IAM (`allow_unauthenticated = false`), aunque el ingress esté en `INGRESS_TRAFFIC_ALL`.

### Requisito de autenticación service-to-service

- La aplicación WEB debe enviar un Google OIDC ID token cuando llame al MCP.
- El `audience` del token debe ser la URL base del servicio MCP.
- Terraform no implementa ese token; es responsabilidad del código de aplicación.

## Relación MCP ↔ Bucket

- MCP recibe `DOCUMENTATION_BUCKET` y `DOCUMENTATION_PREFIX` como variables de entorno.
- Acceso de lectura controlado por IAM sobre el bucket privado.

## Vertex AI

WEB usa Vertex AI/Gemini mediante:
- `GOOGLE_CLOUD_PROJECT`
- `GOOGLE_CLOUD_LOCATION`
- `GEMINI_MODEL`
- rol IAM `roles/aiplatform.user`

## Comandos

Desde `infra/`:

```bash
terraform init -backend-config=backend_dev.hcl
terraform fmt -recursive
terraform validate
terraform plan -var-file=envs/terraform_prod.tfvars
terraform apply -var-file=envs/terraform_prod.tfvars
```

Destroy (si aplica):

```bash
terraform destroy -var-file=envs/terraform_prod.tfvars
```

## Flujo recomendado para imágenes y despliegue

### Fase 1: base de infraestructura

- Habilitar APIs
- Crear Artifact Registry
- Crear bucket GCS
- Crear service accounts
- Crear IAM

### Fase 2: imágenes

- Build imagen WEB
- Push imagen WEB a Artifact Registry
- Build imagen MCP
- Push imagen MCP a Artifact Registry

### Fase 3: Cloud Run

- Actualizar `web_image` y `mcp_image` en `envs/terraform_prod.tfvars`
- Ejecutar `terraform plan -var-file=envs/terraform_prod.tfvars`
- Ejecutar `terraform apply -var-file=envs/terraform_prod.tfvars`

Si `web_image` o `mcp_image` mantienen `PLACEHOLDER`, Cloud Run no podrá desplegar correctamente.

## Costos aproximados

Dependen de uso real. Componentes principales de costo:
- Cloud Run (CPU/memoria por request e instancias)
- Artifact Registry (almacenamiento de imágenes)
- GCS (almacenamiento + operaciones)
- Vertex AI (tokens inferencia)

No hay recursos de Billing/Budget en este MVP.

## Troubleshooting

- `terraform init` falla por backend GCS:
  - Verifica bucket bootstrap existente y permisos.
- `Cloud Run` falla por imagen no encontrada:
  - Publica `web_image` y `mcp_image` primero.
- `403` WEB -> MCP:
  - Verifica binding `roles/run.invoker` sobre servicio MCP.
- `403` MCP -> GCS:
  - Verifica `roles/storage.objectViewer` sobre bucket.
- Errores Vertex AI:
  - Verifica API `aiplatform.googleapis.com` y rol `roles/aiplatform.user`.
