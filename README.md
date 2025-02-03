# Projeto Extrator Firebird

## Descrição
Este projeto tem como objetivo realizar a extração de dados para a integração de clientes do **PGFarma** e seus whitelabels que utilizam sistemas baseados em bancos de dados **Firebird**.

## Requisitos
Para utilizar este projeto corretamente, é necessário atender aos seguintes requisitos:

### Ambiente Python
- **Python 3.9** (recomendado o uso de um ambiente virtual dedicado).
- Instalação das dependências necessárias via `pip install -r requirements.txt`.

### Banco de Dados
- **Firebird Server** instalado na máquina.
- O instalador do **Firebird Server** está incluído no projeto.

## Configuração e Uso
1. Clone este repositório:
   ```sh
   git clone https://github.com/PGFarma-Software/Projeto-Extrator-Firebird.git
   ```
2. Acesse o diretório do projeto:
   ```sh
   cd Projeto-Extrator-Firebird
   ```
3. Crie e ative um ambiente virtual:
   ```sh
   python3.9 -m venv venv
   source venv/bin/activate  # Linux/macOS
   venv\Scripts\activate  # Windows
   ```
4. Instale as dependências do projeto:
   ```sh
   pip install -r requirements.txt
   ```
5. Certifique-se de que o **Firebird Server** está instalado e configurado corretamente.
6. Execute o extrator conforme a documentação do projeto.

## Uso Portátil
Para rodar o projeto sem a necessidade de instalação do Python na máquina de destino, utilize a opção de execução portátil:
1. Execute o script `criar_executavel.bat`, incluso no projeto.
2. O executável empacotado pelo **PyInstaller** será gerado.
3. Utilize o arquivo `.exe` gerado para rodar o extrator em qualquer máquina sem necessidade de instalar o Python.

## Contribuição
Contribuições são bem-vindas! Caso queira sugerir melhorias ou reportar problemas, abra uma issue ou envie um pull request.

## Licença
Este projeto está licenciado sob a [MIT License](LICENSE).

