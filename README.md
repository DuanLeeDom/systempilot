# Script de Atualização e Limpeza do Windows (.BAT)

Este script em **Batch** foi desenvolvido para automatizar processos de manutenção e atualização no Windows.  
Ele centraliza, em um único menu interativo, funções como:

- Atualização do sistema Windows e seus componentes.
- Atualização do Windows Defender.
- Atualização de programas via **winget**.
- Limpeza completa de arquivos temporários, caches de navegadores (Edge, Chrome, Firefox, Brave) e logs do sistema.

Ideal para administradores, técnicos e usuários que desejam manter o sistema otimizado sem precisar executar manualmente diversos comandos.

---

## ⚙️ Funções Disponíveis

1. **Atualizar o Sistema Windows**  
   Executa verificações e reparos de integridade do sistema, habilita e reinicia o serviço de atualização e força a busca por updates.

2. **Atualizar o Windows Defender**  
   Faz o download das últimas definições de vírus e malware.

3. **Atualizar Programas com Winget**  
   Atualiza todos os aplicativos instalados que possuam versões mais recentes disponíveis no repositório do `winget`.

4. **Atualizar Tudo**  
   Executa as três funções anteriores em sequência.

5. **Limpar o Cache e Arquivos Temporários**  
   Remove arquivos temporários do Windows, esvazia a lixeira, exclui caches e dados desnecessários de navegadores suportados, e limpa logs de sistema.

---

## ▶️ Como Executar

1. Baixe ou crie o arquivo com o conteúdo do script.
2. Salve-o em um local de fácil acesso.
3. Clique com o **botão direito** sobre o arquivo e escolha **"Executar como administrador"**.
4. No menu exibido no terminal, digite o número ou letra correspondente à função desejada e pressione **Enter**.

---

## ⚠️ Avisos Importantes

- A execução como administrador é **obrigatória** para que todas as funções funcionem corretamente.  
- Durante a limpeza, **dados temporários de navegadores serão removidos** — incluindo cache e arquivos locais.
- Alguns processos (como limpeza ou atualização) podem demorar alguns minutos, dependendo do desempenho do computador.

---

## 📜 Créditos

- Script de limpeza baseado na versão 1.2c (30/06/2023) de Baboo, adaptado e integrado ao menu de manutenção.
