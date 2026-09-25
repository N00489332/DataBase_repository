db.createCollection("atenciones")
db.atenciones.insertOne({
    año: 2020,
    mes: 9,
    region: "LA LIBERTAD",
    provincia: "PATAZ",
    distrito: "PARCOY",
    ipress: "VAQUERIA DE ANDAS",
    nivel_eess: "I",
    plan_seguro: "SIS GRATUITO",
    servicio: {
        codigo: 62,
        descripcion: "ATENCIÓN POR EMERGENCIA"
    },
    paciente: {
        sexo: "FEMENINO",
        grupo_edad: "18 - 29 AÑOS"
    },
    atenciones: 1
})
db.atenciones.insertMany([
    {
        año: 2020,
        mes: 9,
        region: "LA LIBERTAD",
        provincia: "PATAZ",
        distrito: "PARCOY",
        sexo: "MASCULINO",
        grupo_edad: "30 - 59 AÑOS",
        atenciones: 2
    },
    {
        año: 2020,
        mes: 9,
        region: "LA LIBERTAD",
        provincia: "PATAZ",
        distrito: "PARCOY",
        sexo: "FEMENINO",
        grupo_edad: "0 - 11 AÑOS",
        atenciones: 3
    }
])