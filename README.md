Esse script Bash é uma ferramenta de automação para coletar informações sobre domínios e realizar varreduras de segurança utilizando ferramentas como Amass, GAU, Nmap e Katana. Aqui está uma descrição detalhada do que ele faz:

Descrição do Script
Verificação de Dependências: O script começa verificando se os programas necessários (amass, gau, katana, nmap) estão instalados. Se algum deles não estiver, o script informa o usuário e encerra.

Entrada do Usuário:

Solicita ao usuário o domínio a ser analisado.
Verifica se o domínio foi informado e, caso contrário, encerra o script.
Pede ao usuário o nome da pasta onde os resultados serão salvos e cria essa pasta.
Definição de Arquivos de Saída: Cria variáveis para armazenar os nomes dos arquivos onde os resultados das ferramentas serão salvos.

Varredura de Subdomínios: Utiliza o Amass para encontrar subdomínios do domínio informado e salva os resultados em um arquivo.

Validação de IPs: Valida os IPs dos subdomínios encontrados e os salva em um arquivo separado.

Escolha da Varredura Nmap: Oferece ao usuário várias opções de varredura Nmap, permitindo que ele escolha a que deseja executar. As opções incluem diferentes tipos de varreduras, como varreduras stealth e de descoberta de hosts.

Execução do Nmap: Para cada IP validado, o script executa o comando Nmap escolhido e salva os resultados em arquivos individuais.

Execução do GAU: Executa o GAU para coletar URLs relacionadas aos subdomínios encontrados e salva os resultados.

Execução do Katana: Utiliza o Katana para coletar informações adicionais dos subdomínios com base em várias fontes.

Finalização: O script informa ao usuário que a varredura foi concluída e onde os resultados foram salvos.

Como Usar
Pré-requisitos: Certifique-se de ter as ferramentas amass, gau, katana e nmap instaladas no sistema.
Execução: Salve o script em um arquivo .sh, dê permissão de execução (chmod +x script.sh) e execute-o (./script.sh).
Considerações Finais
Esse script é útil para profissionais de segurança da informação e entusiastas que desejam automatizar a coleta de informações sobre domínios e realizar varreduras de forma eficiente. É uma ótima adição a um repositório no GitHub, pois pode ajudar outros usuários a entender melhor como usar essas ferramentas em conjunto.
