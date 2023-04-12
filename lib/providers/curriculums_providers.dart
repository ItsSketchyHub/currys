// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:proyecto_currys/dtos/request/curriculum_request_dto.dart';
import 'package:proyecto_currys/dtos/response/curriculums_responseDto.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_currys/pages/home/paginas_principales/creacion_curriculum.dart';

class CurriculumsProviders extends ChangeNotifier {
  final logger = Logger();
  bool isloading = true;
  bool userFound = true;
  CurriculumRequestDto? _CurriculumRequestDto;
  // CurriculumResponseDto? get curriculumResponseDto => _CurriculumResponseDto;
  List<CurriculumRequestDto>? _curriculums;

  Future createCurriculum(
      String nombre,
      String apellidos,
      String correo,
      String telefono,
      String direccion,
      String descripcion,
      List<Education> educacion,
      List<Experience> experiencia,
      BuildContext context) async {
    final curriculum = CurriculumRequestDto(
        firstName: nombre,
        lastName: apellidos,
        email: correo,
        phoneNumber: telefono,
        address: direccion,
        summary: descripcion,
        education: educacion,
        experience: experiencia);

    final response = await http.post(
        Uri.parse('http://currysapi.somee.com/api/curriculum'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(curriculum));
    print(response.statusCode);
    if (response.statusCode == 200) {
      if (context.mounted) {
        userFound = true;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Haz creado tu Curriculum Vitae'),
              content: const Text('ya puedes Consultar tu curriculum desde la web'),
              actions: [
                TextButton(
                  child: const Text('Entendido'),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const SecondRoute()));
                  },
                ),
              ],
            );
          },
        );
      }else{
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error al crear'),
                content: const Text('no se pudo crear tu Curriculum Vitae'),
                actions: [
                  TextButton(
                    child: const Text('Entendido'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }
}