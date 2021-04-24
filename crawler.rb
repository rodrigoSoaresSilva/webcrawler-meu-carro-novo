# encoding: utf-8

require 'mechanize'
require 'json'

API_MEU_CARRO_NOVO_FB = "https://www.meucarronovo.com.br/api/busca/index/format/json?"

# Função de rastreio
# Faz a busca dos veículos, alimenta um json com informações relevantes e salva a imagem de capa.
def search_veicle_ads(city, type, limit)
  ads = []

  case type
  when 1
    type = 'carro'
  when 2
    type = 'moto'
  when 3
    type = 'caminhao'
  else
    type = 'carro'
  end

  crawler = Mechanize.new
  url = API_MEU_CARRO_NOVO_FB + "limit=" + limit.to_s + "&p=1&cidade=" + city + "&tipo-veiculo=" + type
  page = crawler.get url

  body = JSON.parse(page.body)

  if body["totalResultadosBusca"] > 0
    items = body["result"]["docs"]
    items.each do |node|
      ad = {
        "modelo" => node["mode_nome"],
        "marca" => node["marc_nome"],
        "valor" => node["veic_valorfinal"],
        "ano_fabricacao" => node["veic_anofabricacao"],
        "ano_modelo" => node["veic_anomodelo"],
        "local_path" => get_foto_capa(node["foto_capa"])
      }

      ads.push(ad)
    end
  else
    puts ""
    puts "A pesquisa não encontrou nenhum anúncio para os dados informados."
    puts ""
  end

  puts ads.to_json
end

# Lê uma imagem e grava na pasta images
def get_foto_capa(uri)
  crawler = Mechanize.new

  src = crawler.get "https://static2.meucarronovo.com.br/imagens-dinamicas/lista/fotos/" + uri
  filename = "images/#{File.basename(uri)}"

  crawler.get(src).save filename
  return filename
end

# Coleta os dados da busca personalizada.
def collect_data()
  puts ""
  puts "Digite a cidade a ser buscada:"
  puts ""
  city = gets.chomp

  type = nil

  loop do
    puts ""
    puts "Qual tipo de veículo você está buscando?"
    puts "[1] Carro"
    puts "[2] Moto"
    puts "[3] Caminhão/Ônibus"
    puts ""
    type = gets.chomp
    type = type.to_i

    if type > 0 && type < 4
      break
    else
      puts ""
      puts "Por favor, selecione um tipo válido."
      puts ""
    end
  end

  puts ""
  puts "Qual o limite de registros a serem retornados pela busca? Informe um múltiplo de 10 ou pressione ENTER para o padrão de 20 registros."
  puts ""
  limit = gets.chomp
  limit = limit.nil? || limit.empty? || limit !~ /^[1-9]\d*$/ ? 20 : limit.to_i

  search_veicle_ads(city, type, limit)
end

# Realiza a interação inicial com o usuário e coleta dados dependendo do modo selecionado.
def user_interaction()
  loop do
    puts "Selecione o modo de busca a ser utilizado:"
    puts "[1] Padrão"
    puts "[2] Personalizado"
    puts ""
    modo = gets.chomp.to_i

    if modo == 1
      puts ""
      puts "Realizando busca de veículos para a cidade de Francisco Beltrão."
      search_veicle_ads('francisco beltrao', 1, 20)
    elsif modo == 2
      collect_data()
    else
      puts ""
      puts "Por favor, selecione um modo válido."
      puts ""
    end

    if modo == 1 || modo == 2
      break
    end
  end
end

#Método principal.
def main()
  puts ""
  puts "Script de busca de veículos no site Meu Carro Novo. Versão 1.0.0."
  puts ""

  user_interaction()
end

main()
