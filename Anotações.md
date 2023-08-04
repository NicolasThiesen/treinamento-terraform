# Anotações do Curso

## Teste no terraform

**Existem alguns frameworks:**
- https://terratest.gruntwork.io/
- https://docs.localstack.cloud/user-guide/integrations/terraform/


## Comandos git
- `git diff [branch]..[branch]` -> diferença entre duas branchs
- `git log [branch]..[branch]` -> log entre duas branchs
- `git checkout [branch] -- [arquivo]` -> copia uma arquivo em específico para a branch atual
- `git config merge.ff true` -> aplica a remoção do commit extra nas configurações do merge
- `git rebase [branch]` -> coloca todos os commits da branch atual na frente do último commit na branch alvo
Antes:
```
            A---B---C topic
         /
    D---E---A---F master
```
Depois
```
                   B'---C' topic
                  /
    D---E---A---F master
```


## Comandos terraform

- `terraform plan` -> dry run nos arquivos (simula o apply)
- `terraform validate` -> valida o arquivo
- `terraform fmt [arquivo]` -> formata o arquivo 
- `terraform show` -> mostra tanto recursos quanto outputs dos arquivos
- `terraform output` -> mostra os outputs dos arquivos



