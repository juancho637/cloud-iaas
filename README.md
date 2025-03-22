# Proyecto IaaS en Azure con Terraform

Este proyecto despliega una infraestructura en Azure que incluye:

- **Dos VMs Linux (grupo LB)**:  
  Se utilizan para ejecutar un contenedor Docker (usando la imagen `traefik/whoami`) y se ubican detrás de un Load Balancer para redirigir tráfico HTTP en el puerto 80.

- **Una VM Linux con Disco**:  
  Esta máquina tiene un disco administrado adicional. Se usa para demostrar la utilización del disco (por ejemplo, creando un archivo dummy en `/data`). Cuenta con su propia IP pública para acceso directo vía SSH.

- **Una VM Windows**:  
  Desplegada para acceso vía RDP, con su respectiva configuración de red.

A continuación, se detalla la función de cada archivo de la solución:

## Estructura de Archivos y Descripción

1. **01-provider.tf**  
   - Define los proveedores utilizados: `azurerm` y `tls`.  
   - Se usa la variable `subscription_id` para conectarse a la suscripción de Azure.

2. **01.1-variables.tf**  
   - Declara la variable `subscription_id` (ID de la suscripción de Azure).

3. **02-resource_group.tf**  
   - Crea el grupo de recursos `miResourceGroup` en la región "Central US".

4. **03-network_linux.tf**  
   - Define la Virtual Network (VNET) y la subred llamada `linuxSubnet` para las VMs Linux que formarán parte del grupo detrás del Load Balancer.

5. **04-public_ip_lb.tf**  
   - Crea la IP pública para el Load Balancer (`lbPublicIP`) con asignación estática y SKU Standard.

6. **05-linux_nic_lb.tf**  
   - Crea las interfaces de red (NIC) para las 2 VMs Linux que estarán detrás del Load Balancer.  
   - Estas NIC no tienen IP pública asignada, ya que el tráfico se redirige a través del LB.

7. **06-linux_nsg.tf**  
   - Define un Network Security Group (NSG) para las VMs Linux del grupo LB, permitiendo el tráfico entrante en el puerto 22 (SSH) y 80 (HTTP).

8. **07-linux_nic_nsg_assoc.tf**  
   - Asocia el NSG definido en el archivo anterior a cada una de las NIC creadas para las VMs Linux del grupo LB.

9. **08-ssh_key.tf**  
   - Genera un par de llaves SSH (RSA de 4096 bits) para autenticar el acceso a las VMs Linux.

10. **09-linux_vm_lb.tf**  
    - Despliega las dos VMs Linux que estarán detrás del Load Balancer.  
    - Utiliza `cloud-init` (archivo **19-cloud-init.txt**) para actualizar el sistema, instalar Docker y lanzar el contenedor `traefik/whoami`.

11. **10-load_balancer.tf**  
    - Configura el Azure Load Balancer:  
      - Asocia la IP pública creada en **04-public_ip_lb.tf** al frontend.  
      - Define el backend pool, un health probe HTTP (que verifica la ruta `/`) y una regla de balanceo que redirige el tráfico del puerto 80 hacia las VMs Linux del backend.

12. **11-network_disk.tf**  
    - Define una subred separada, `diskSubnet`, para la VM Linux que utilizará un disco adicional.

13. **12-public_ip_linux_disk.tf**  
    - Crea la IP pública para la VM Linux con disco (`linuxDiskPublicIP`) con asignación estática y SKU Standard.

14. **13-linux_nic_disk.tf**  
    - Crea la NIC para la VM Linux con disco, asociándola a la subred `diskSubnet` y a la IP pública definida en el archivo anterior.

15. **13.1-linux_disk_nsg.tf**  
    - Define un NSG exclusivo para la VM Linux con disco, permitiendo tráfico entrante en el puerto 22 (SSH).

16. **13.2-linux_disk_nic_nsg_assoc.tf**  
    - Asocia el NSG definido en **13.1-linux_disk_nsg.tf** a la NIC creada para la VM Linux con disco.

17. **14-linux_vm_disk.tf**  
    - Despliega la VM Linux con disco (llamada `miUbuntuVM-Disk`).  
    - Utiliza un `cloud-init` distinto (archivo **20-cloud-init-disk.txt**) para montar el disco y crear un archivo dummy en `/data`.

18. **15-linux_data_disk.tf**  
    - Crea un disco administrado (10 GB) y lo asocia a la VM Linux con disco mediante attachment.

19. **16-network_windows.tf**  
    - Define la subred `windowsSubnet` para la VM Windows y crea la IP pública para la misma (SKU Standard, asignación estática).

20. **17-windows_vm.tf**  
    - Despliega la VM Windows (llamada `miWindowsVM`) configurada para RDP, con su NIC y la IP pública creada en **16-network_windows.tf**.

21. **18-outputs.tf**  
    - Define los outputs del proyecto para mostrar:  
      - La IP pública del Load Balancer.  
      - La IP pública de la VM Linux con disco.  
      - La IP pública de la VM Windows.  
      - La llave privada SSH para acceder a las VMs Linux (marcada como sensible).

22. **19-cloud-init.txt**  
    - Script de inicialización (cloud-init) para las VMs Linux del grupo LB.  
    - Actualiza el sistema, instala Docker y lanza el contenedor `traefik/whoami` en el puerto 80.

23. **20-cloud-init-disk.txt**  
    - Script de inicialización para la VM Linux con disco.  
    - Formatea y monta el disco en `/data`, y crea un archivo dummy (`dummy.txt`) para demostrar la utilización del disco.

24. **terraform.tfvars.example**  
    - Archivo de ejemplo para definir la variable `subscription_id`.  
    - Renómbralo a `terraform.tfvars` y agrega el valor de tu suscripción de Azure.

25. **.terraform.lock.hcl**  
    - Archivo generado automáticamente por Terraform para bloquear las versiones de los proveedores.

## Pasos para Desplegar la Infraestructura

1. **Configurar Variables:**  
   - Renombra el archivo `terraform.tfvars.example` a `terraform.tfvars` y agrega tu `subscription_id` de Azure.

2. **Inicializar Terraform:**  
   ```bash
   terraform init
   ```
   
3. **Ver plan de Terraform:**  
   ```bash
   terraform plan
   ```

4. **aplicar plan de Terraform:**  
   ```bash
   terraform apply
   ```

5. **Acceder a las Máquinas:**  
   ```bash
   terraform output -raw ssh_private_key > id_rsa
   chmod 600 id_rsa
   ssh azureuser@<IP_LINUX_DISK> -i id_rsa
   ```