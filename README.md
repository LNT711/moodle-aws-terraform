# Moodle en AWS con Terraform, ECS Fargate y RDS Multi-AZ

Trabajo Fin de Máster (TFM) del **Máster Universitario en DevOps — UNIR, 2025**.

Infraestructura como código que despliega una plataforma Moodle en alta disponibilidad sobre AWS, a partir de una imagen Docker personalizada. El objetivo es reducir el tiempo de puesta en marcha de nuevas aulas virtuales y hacer cada despliegue repetible.

## Arquitectura

```
Internet ──► Application Load Balancer (subredes públicas, 2 AZ)
                    │
                    ▼
            ECS Fargate · contenedor Moodle (subredes privadas)
               │                         │
               ▼                         ▼
     RDS MariaDB Multi-AZ        EFS (moodledata compartido)
               
Salida a Internet desde subredes privadas vía NAT Gateway · Logs en CloudWatch
```

| Módulo Terraform | Recursos |
|---|---|
| `vpc` | VPC, 2 subredes públicas y 2 privadas, Internet Gateway, NAT Gateway, tablas de rutas |
| `security_groups` | Security Groups para el balanceador y la aplicación |
| `load_balancer` | Application Load Balancer, target group con health check y listener HTTP |
| `ecs` | Clúster ECS, task definition Fargate, servicio y log group de CloudWatch |
| `rds` | RDS MariaDB 10.6 Multi-AZ, subnet group y parameter group |
| `efs` | EFS para `moodledata` con mount targets en las subredes privadas |

## Imagen Docker personalizada (`crearimagen/`)

Basada en `bitnami/moodle:4.2`, con configuración propia de PHP y Apache (MPM) y virtual hosts generados desde plantilla (`generate-vhost.sh` + `vhost-config.env`). Se construye y prueba en local con `make`.

```bash
cd crearimagen
make build   # construye la imagen moodle-tfm
make run     # levanta los contenedores en local
```

## Despliegue

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars   # completar credenciales y variables
terraform init
terraform plan
terraform apply
```

Video del despliegue: [`terraform/TFM Despliegue.mp4`](terraform/TFM%20Despliegue.mp4)

## Tecnologías

Terraform · AWS (VPC, ALB, ECS Fargate, RDS, EFS, NAT Gateway, CloudWatch, IAM) · Docker · Docker Compose · Moodle · MariaDB · Apache · PHP · Make

## Autores

- Loren E. Camacho Quintana ([@LNT711](https://github.com/LNT711))
- [@NavarroMarin](https://github.com/NavarroMarin)

> Las credenciales usadas durante el desarrollo se eliminaron del historial antes de publicar el repositorio.
