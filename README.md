# Webcrawler

Este é um projeto Ruby criado para fins de demonstração do funcionamento de um **webcrawler**.
O script faz uma leitura da API de busca do site meucarronovo.com.br e imprime na tela um json dos resultados, também salva no diretório *images* a foto de capa de cada anúncio.
Este script tem dois modos: **padrão** e **personalizado**.

## Modo padrão

Busca por carros na cidade de Francisco Beltrão e limita o resultado em 20 registros.

## Modo personalizado

Permite definir a cidade, o tipo de veículo e o limite de registros a serem retornados.

# Dependências

Os seguintes recursos foram utilizados neste projeto:

 1. Módulo **json**, nativo do Ruby
 2. Módulo **file**, nativo do Ruby
 3. Gem **[mechanize](https://rubygems.org/gems/mechanize)**
