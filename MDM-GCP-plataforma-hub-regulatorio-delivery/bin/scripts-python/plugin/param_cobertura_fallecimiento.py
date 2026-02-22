class PARAMETER_COBERTURA_fALLECIMIENTO:
    parameters_persona = [
        "id_persona",
        "ape_paterno",
        "ape_materno",
        "nom_persona",
        "nom_completo"
    ]

    parameters_persona_documento_identidad = [
        "id_persona_documento_identidad",
        "id_persona",
        "tip_documento",
        "num_documento"
    ]

    parameters_certificado = [
        "id_certificado",
        "id_certificado_origen",
        "fec_ingreso",
        "fec_exclusion",
        "estado_certificado",
        "fec_inicio_vigencia",
        "fec_fin_vigencia",
        "id_poliza",
        "id_titular"
    ]

    parameters_poliza = [
        "id_producto",
        "id_poliza",
        "id_poliza_origen",
        "id_estado_poliza_origen",
        "num_poliza",
        "cod_producto_origen",
        "nom_producto",
        "fec_emision",
        "fec_inicio_vigencia",
        "fec_fin_vigencia",
        "fec_anulacion",
        "id_contratante",
        "des_estado_poliza"
    ]

    parameters_unidad_asegurable = [
        "id_certificado",
        "id_unidad_asegurable",
        "des_parentesco",
        "id_persona"
    ]

    parameters_ramo_unidad_asegurable = [
        "id_unidad_asegurable",
        "id_ramo_unidad_asegurable",
        "des_ramo"
    ]

    parameters_cobertura_unidad_asegurable = [
        "id_ramo_unidad_asegurable",
        "mto_suma_asegurada",
        "des_cobertura_origen",
        "id_moneda"
    ]

    parameters_tasa_cambio = [
        "id_moneda_origen",
        "id_moneda_fin",
        "fec_tasa",
        "tip_tasa_cambio",
        "val_tasa_cambio"
    ]
