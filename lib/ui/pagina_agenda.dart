import 'package:flutter/material.dart';
import 'package:ufscarplanner/helpers/MateriaHelper.dart';

class PaginaAgenda extends StatefulWidget {
  @override
  _PaginaAgendaState createState() => _PaginaAgendaState();
}

class _PaginaAgendaState extends State<PaginaAgenda> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: getTabs(),
    );
  }

  TextStyle _titleTextStyle() => TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  /*
   * Retorna uma string com apenas as primeiras letras maiúsculas.
   * A função não irá capitalizar palavras com 2 caracteres ou menos (i.e: "De", "E", Etc.)
   */
  String _stringDecapitalizer(String str) {
    List<String> splittedString = str.toLowerCase().split(" ");
    String output = "";

    // Coloca apenas a primeira letra como maiúscula e copia o resto
    for (int i = 0; i < splittedString.length; i++) output += splittedString[i].substring(0, 1).toUpperCase() + splittedString[i].substring(1) + " ";

    // Remove o espaço desnecessário do final
    output = output.substring(0, output.length - 1);

    return output;
  }

  /*
   * Fornece as tabs para a página de agenda
   */
  DefaultTabController getTabs() {
    List<Widget> labelDiasDaSemana = List<Widget>();
    List<List<Widget>> cardsDasMaterias = List<List<Widget>>();
    List<Widget> paginas = List<Widget>();

    // Insere o "label" dos dias da semana, que se observa na parte superior da interface
    for (int i = 0; i < MateriaHelper.lista_dias.length; i++) {
      labelDiasDaSemana.add(Text(
        MateriaHelper.lista_dias[i],
        style: TextStyle(
          // Este valor (fontSize), se fixo, pode ser facilmente quebrado pelas dimensões do dispositivo.
          // Disto parte a necessidade de calculá-lo com base no contexto.
          // O valor que se observa foi *obtido por experimentação*, e é arbitrário.
          fontSize: MediaQuery.of(context).size.width * 0.044,
        ),
      ));

      // Inicializa uma nova lista vazia.
      // Nela serão inseridas as informações das matérias do dia
      cardsDasMaterias.add(new List<Widget>());

      // Adiciona os cards das matérias
      for (int j = 0; j < MateriaHelper.lista_materias[i].length; j++) {
        cardsDasMaterias[i].add(Container(
          width: MediaQuery.of(context).size.width * 0.95,
          child: Card(
              margin: EdgeInsets.only(top: 15),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(bottom: 10),
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF000000)))),
                      child: Text(
                        this._stringDecapitalizer(MateriaHelper.lista_materias[i][j].nome),
                        style: _titleTextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      MateriaHelper.lista_materias[i][j].ministrantes.trim().isEmpty
                          ? "(ministrante não informado)"
                          : MateriaHelper.lista_materias[i][j].ministrantes.trim(),
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xAA000000),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    // Chips de horário
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text(
                            // O ternário abaixo garante que os horários sempre tenham a mesma
                            // quantidade de caracteres
                            MateriaHelper.lista_materias[i][j].horaI.length < 5
                                ? "0" + MateriaHelper.lista_materias[i][j].horaI
                                : MateriaHelper.lista_materias[i][j].horaI,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 1, offset: Offset(0, 1))],
                              gradient: LinearGradient(colors: [Color.fromRGBO(150, 255, 150, 1), Color.fromRGBO(175, 255, 175, 1)]),
                              borderRadius: BorderRadius.circular(2)),
                        ),
                        SizedBox(
                          width: 13,
                        ),
                        Container(
                          child: Text(
                            // O ternário abaixo garante que os horários sempre tenham a mesma
                            // quantidade de caracteres
                            MateriaHelper.lista_materias[i][j].horaF.length < 5
                                ? "0" + MateriaHelper.lista_materias[i][j].horaF
                                : MateriaHelper.lista_materias[i][j].horaF,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 1, offset: Offset(0, 1))],
                              gradient: LinearGradient(colors: [Color.fromRGBO(255, 150, 150, 1), Color.fromRGBO(255, 175, 175, 1)]),
                              borderRadius: BorderRadius.circular(2)),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[Icon(Icons.place), Text(MateriaHelper.lista_materias[i][j].local)],
                    )
                  ],
                ),
              )),
        ));
      }
      paginas.add(SingleChildScrollView(
        child: Column(
          children: cardsDasMaterias[i],
        ),
      ));
    }

    return DefaultTabController(
      length: MateriaHelper.lista_dias.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // here the desired height
          child: AppBar(
            bottom: TabBar(
              tabs: labelDiasDaSemana,
            ),
          ),
        ),
        body: TabBarView(
          children: paginas,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){print("Botão flutuante pressionado");},
          child: Icon(Icons.add),
          backgroundColor: Colors.redAccent,
        ),
      ),
    );
  }
}
