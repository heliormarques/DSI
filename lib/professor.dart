import 'package:dsi_app/constants.dart';
import 'package:dsi_app/dsi_widgets.dart';
import 'package:dsi_app/infra.dart';
import 'package:dsi_app/pessoa.dart';
import 'package:flutter/material.dart';

/// A classe professor representa um professor do sistema e é uma subclasse de Pessoa.
/// Assim, tudo o que Pessoa possui, um professor também possui.
/// E todas as operações que podem ser feitas com uma pessoa, também podem ser
/// feitas com um professor. Assim, todos os métodos e funções que recebiam uma
/// Pessoa como parâmetro, também podem receber também um Professor.
class Professor extends Pessoa {
  String matricula;

  //TIP Observe que o construtor de professor repassa alguns dos parâmetros recebidos
  //para o construtor da super classe (Pessoa).
  Professor({cpf, nome, endereco, this.matricula})
      : super(cpf: cpf, nome: nome, endereco: endereco);

  //TIP Observe que é delegada para a superclasse a conversão dos seus
  //atributos específicos. Esta chamada deve ser a última coisa a ser feita
  //no construtor.
  Professor.fromJson(Map<String, dynamic> json)
      : matricula = json['matricula'],
        super.fromJson(json);

  ///TIP este método converte o objeto atual para um mapa que representa um
  ///objeto JSON. Observe que a conversão do objeto endereço é delegada para
  ///o próprio objeto, seguindo o princípio do encapsulamento.
  ///Observe o uso do cascade notation do flutter. Caso este atalho não fosse
  ///usado, seria preciso criar o método com corpo, chamando o super.toJson()
  ///e atribuindo o mapa a uma variável, em seguida adicionar as novas entradas
  ///no mapa, para só então retornar o mapa como resultado do método:
  ///``
  ///var result = super.toJson();
  ///result.addAll({
  ///       'matricula': matricula,
  ///     });
  ///return result;
  ///``
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'matricula': matricula,
    });
}

var professorController = ProfessorController();

class ProfessorController {
  List<Professor> getAll() {
    return pessoaController.getAll().whereType<Professor>().toList();
  }

  Professor save(professor) {
    return pessoaController.save(professor);
  }

  bool remove(professor) {
    return pessoaController.remove(professor);
  }
}

class ListProfessorPage extends StatefulWidget {
  @override
  ListProfessorPageState createState() => ListProfessorPageState();
}

class ListProfessorPageState extends State<ListProfessorPage> {
  List<Professor> _professors = professorController.getAll();

  @override
  Widget build(BuildContext context) {
    return DsiScaffold(
      title: 'Listagem de Professors',
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => dsiHelper.go(context, '/maintain_professor'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        // physics: NeverScrollableScrollPhysics(),
        itemCount: _professors.length,
        itemBuilder: _buildListTileProfessor,
      ),
    );
  }

  Widget _buildListTileProfessor(context, index) {
    var professor = _professors[index];
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          professorController.remove(professor);
          _professors.remove(index);
        });
        dsiHelper.showMessage(
          context: context,
          message: '${professor.nome} foi removido.',
        );
      },
      background: Container(
        color: Colors.red,
        child: Row(
          children: <Widget>[
            Constants.boxSmallWidth,
            Icon(Icons.delete, color: Colors.white),
            Spacer(),
            Icon(Icons.delete, color: Colors.white),
            Constants.boxSmallWidth,
          ],
        ),
      ),
      child: ListTile(
        title: Text(professor.nome),
        subtitle: Text('mat. ${professor.matricula}'),
        onTap: () => dsiHelper.go(context, "/maintain_professor", arguments: professor),
      ),
    );
  }
}

class MaintainProfessorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Professor professor = dsiHelper.getRouteArgs(context);
    if (professor == null) {
      professor = Professor();
    }

    return DsiBasicFormPage(
      title: 'Professor',
      onSave: () {
        professorController.save(professor);
        dsiHelper.go(context, '/list_professor');
      },
      body: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: Constants.boxSmallHeight.height,
        children: <Widget>[
          MaintainPessoaBody(professor),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Matrícula*'),
            validator: (String value) {
              return value.isEmpty ? 'Matrícula inválida.' : null;
            },
            initialValue: professor.matricula,
            onSaved: (newValue) => professor.matricula = newValue,
          ),
        ],
      ),
    );
  }
}
