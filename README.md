# Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) instalado;
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) instalado e configurado com credenciais válidas (`~/.aws/credentials`);  
- Bucket S3 criado, com o versionamento habilitado e referenciado corretamente no `backend.tf`, assim como região e perfil AWS para acesso ao bucket;  
- Variáveis ajustadas no arquivo `terraform.tfvars`:  
  - `aws_profile`  # Perfil AWS utilizado para criação dos recursos;
  - `region`  # Região onde os recursos serão criados;
  - `meu_ip`  # IP de ORIGEM para acesso SSH ao servidor (acesse meuip.com para saber seu IP de origem);
  - Outras variáveis de infraestrutura, se necessário.  

---

# Aplicação da infraestrutura e deploy do NGINX

1. Clone este repositório e acesse o diretório:

   ```bash
   git clone https://github.com/luan-nabarrete/Test-Kubernetes-Terraform.git
   cd Test-Kubernetes-Terraform
   ```

2. Inicialize o Terraform:

   ```bash
   terraform init
   ```

3. (Opcional) Verifique o plano:

   ```bash
   terraform plan
   ```

4. Aplique o plano:

   ```bash
   terraform apply
   ```

   Confirme com `yes` quando solicitado.

---

# Aguarde a criação da EC2

O script localizado em `modules/ec2/user_data.sh` será executado automaticamente pela EC2 provisionada e:

1. Instala Docker, Kind, kubectl e Helm  
2. Cria um cluster Kubernetes local com Kind  
3. Aplica automaticamente o Helm chart localizado em `helm/`  

>  **Importante:** esse processo leva aproximadamente 5 minutos após a inicialização da EC2. Aguarde antes de acessar o serviço.

---

## Teste de acesso ao NGINX

Ao final do `terraform apply`, os seguintes outputs serão exibidos:

```
Apply complete! Resources: X added, Y changed, Z destroyed.

Outputs:

ec2_public_ip = "192.163.10.51"
ec2_public_ip_port = "192.163.10.51:30080"
```

Acesse via navegador:

```
http://192.163.10.51:30080
```

Ou via terminal:

```bash
curl 192.163.10.51:30080
```

>  **Obs.:** Os endereços IP acima são fictícios, substituia pelo valor exibido localmente.

---

## Acesso SSH à EC2

Uma chave SSH chamada `server-key.pem` foi gerada automaticamente e está salva em `modules/ec2/`.

Comando para acesso:

```bash
ssh -i modules/ec2/server-key.pem ec2-user@[ec2_public_ip]
```

Exemplo:

```bash
ssh -i modules/ec2/server-key.pem ec2-user@192.163.10.51
```

---

## Deletar os recursos

Para deletar todos recursos criados, execute:

```bash
terraform destroy
```

Confirme com `yes` quando solicitado.

---



## Estrutura do Projeto

```text
.
├── backend.tf
├── main.tf
├── provider.tf
├── terraform.tfvars
├── variables.tf
├── README.md
├── helm/
│   ├── Chart.yaml
│   ├── values.yaml
│   ├── kind-app-nginx-cluster.yaml
│   └── templates/
│       ├── deployment.yaml
│       └── service.yaml
└── modules/
    ├── ec2/
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── server-key.pem
    │   ├── user_data.sh
    │   └── variables.tf
    ├── security_groups/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    └── vpc/
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

---

##  Correções aplicadas

-  **Adicionado o arquivo `service.yaml`** ao chart Helm para expor a aplicação via serviço Kubernetes.
-  **Corrigidos erros de indentação** no `deployment.yaml`, que impediam a criação correta do deployment.
-  A porta configurada para os pods era `8080`, mas a imagem oficial do NGINX expõe a porta `80` — isso foi corrigido para permitir o acesso adequado.
-  O tipo de serviço original era `ClusterIP`, que não permite acesso externo. Ele foi alterado para `NodePort`, permitindo acesso público via IP da EC2 e porta mapeada (ex: `:30080`).

---


## Limitação de recursos dos pods

O arquivo `deployment.yaml` do Helm chart foi atualizado com as diretivas `resources.requests` e `resources.limits` para controlar o uso de CPU e memória dos containers no cluster Kind.


## Atualizações no Helm Chart

As seguintes melhorias foram realizadas no Helm Chart para torná-lo mais flexível e reutilizável:

- Foram adicionadas variáveis no arquivo `helm/values.yaml` para tornar o chart parametrizável, permitindo customizações sem alterar diretamente os manifests.
- Agora é possível alterar facilmente:
  - A imagem utilizada (`image.repository` e `image.tag`);
  - As portas de exposição (`containerPort`, `service.port` e `service.nodePort`);
  - O número de réplicas;
  - Os recursos solicitados e limitados (`resources.requests` e `resources.limits`);

Essas variáveis tornam o Helm Chart reutilizável para diferentes aplicações, bastando editar o `values.yaml` ou passar valores com `--set` ou `-f`.
