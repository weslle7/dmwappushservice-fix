# dmwappushservice-fix

Script PowerShell para corrigir o serviço de Notificação por Push do Windows (`dmwappushservice`) e restaurar a sincronização MDM do Intune.

##  Contexto

Alguns dispositivos Windows podem parar de sincronizar com o Intune e apresentar o erro:

> **Não foi possível iniciar a sincronização (0x82ac000b)**

Esse erro ocorre **antes da aplicação de qualquer política**, indicando uma **falha local no mecanismo de MDM do Windows**, e não um problema de tenant ou de configurações do Intune.

Nos dispositivos afetados, a causa raiz geralmente está relacionada ao **serviço `dmwappushservice` corrompido ou mal configurado**, que é essencial para a comunicação por push utilizada pelo MDM.

## O que este script faz

- Reconfigura o serviço `dmwappushservice` de forma segura  
- Garante que o serviço esteja associado ao grupo correto do `svchost`  
- Evita sobrescrever valores críticos do Registro  
- Reinicia o serviço  
- Valida o status do serviço ao final da execução  

## Cenário de aplicação

- Ambientes híbridos ou cloud-only  
- Dispositivos há muito tempo sem sincronizar  
- Falha imediata ao tentar sincronização manual  
- Erro observado: **0x82ac000b**  
- Problema ocorre em **dispositivos específicos**, não em todo o tenant  

## Formas de implantação no Intune

Este script pode ser utilizado de duas formas no Intune:

### Platform Script
- Ideal para ambientes que **não possuem acesso ao Remediation Scripts**
- Executado uma única vez ou sob demanda
- Útil para correção direta em dispositivos já impactados

###  Remediation Script 
- Recomendado quando disponível
- Pode ser adaptado para:
  - **Detection Script** (verificar se o `dmwappushservice` está quebrado)
  - **Remediation Script** (aplicar a correção automaticamente)
- Permite correção contínua e preventiva

## Como usar manualmente

1. Execute o PowerShell como **Administrador** (ou SYSTEM)
2. Navegue até a pasta do script ou copie e cole no terminal.

