package zap;

using StringTools;
using zap.LongString;

class Search {
    inline static var BASE_URL = "http://www.zapimoveis.com.br/Busca/RetornarBuscaAssincrona/";

    public function new()
    {
    }

    public function execute()
    {
        var http = new haxe.Http(BASE_URL);
        http.setParameter("tipoOferta", 'Imovel');
        http.setParameter("paginaAtual", '1');
        http.setParameter("pathName", '/aluguel/apartamentos/agr+sp+sao-paulo+regiao-do-centro/');
        http.setParameter("hashFragment", '{"precominimo":"2500","precomaximo":"4300","filtrovagas":"1;2;","areautilminima":"99","parametrosautosuggest":[{"Bairro":"","Zona":"","Cidade":"SAO PAULO","Agrupamento":"Região do Centro","Estado":"SP"}],"pagina":"1","paginaOrigem":"Home","semente":"984085264"}');
        http.onStatus = function (status) trace(status);  // TODO
        http.onError = function (error) trace('ERROR  $error');  // TODO
        http.request(true);
        // TODO
        trace(http.responseHeaders);
        trace(http.responseData.length);
        trace(http.responseData.substr(0,132));
        var res = haxe.Json.parse(http.responseData);
        trace(res.Resultado.Resultado[0].ZapID);
    }
}

