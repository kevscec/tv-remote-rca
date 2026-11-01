# TV Remote RCA

Fork independiente de [TV Remote de HoangTran0410](https://github.com/HoangTran0410/tv-remote), basado en **v0.39.0**. Adaptación para controlar desde un celular Android un RCA antiguo con firmware Realtek RT2831 / Android 7.1.1. Conserva la licencia MIT y el historial original.

El trabajo nació durante una revisión con [el prompt de CleanYourTV](https://github.com/Gathin23/cleanyourtv/blob/main/PROMPT.md). Se necesitaba reemplazar un control físico perdido. La app original conectaba, pero al volver a abrirla podía mostrar «ADB debugging is off on this TV» aunque la depuración seguía activa. Las pruebas señalaron un conflicto entre las conexiones ADB de la app y el comportamiento de ese firmware.

**[Descargar TV-Remote-RCA.apk](https://github.com/kevscec/tv-remote-rca/releases/latest/download/TV-Remote-RCA.apk)** · [Release y checksums](https://github.com/kevscec/tv-remote-rca/releases/latest). Instálalo en el celular, no en el TV.

## Qué cambia

- Se instala como **TV Remote RCA**, paquete `dev.tvremote.phone.rca`, junto a la app original.
- Desactiva las consultas automáticas de estado por ADB y la preparación de Manage en segundo plano.
- Inicia sin duplicar pantalla y oculta los botones independientes de imagen, escucha y Manage.
- Omite el aviso de instalar TV Setup y las actualizaciones de la app oficial.

La primera publicación del fork es **0.36.1-rca1**, basada en el componente de teléfono 0.36.0 de la publicación original v0.39.0. No es una publicación oficial del autor original.

## Cómo usarlo

1. Descarga el APK del fork e instálalo en el celular. También puedes compilarlo siguiendo [LOCAL-RCA.md](LOCAL-RCA.md).
2. Conecta celular y TV a la misma red local. La depuración ADB del TV debe estar habilitada y autorizada para este mando.
3. Abre **TV Remote RCA** y selecciona o agrega tu TV. Cierra otros mandos ADB y desconecta el ADB del PC antes de conectarlo.

**picture off** indica que no se duplica la pantalla en el celular. El mando puede seguir conectado y funcionando.

El APK del release conserva la firma de la primera instalación local del RCA, por lo que puede actualizarla sin borrar sus datos. Las actualizaciones se descargan e instalan manualmente desde este repositorio. Los enlaces y códigos Downloader de los documentos originales apuntan al proyecto original. Los APK de prueba de CI usan una firma temporal distinta: usa el APK del release para actualizar la instalación publicada.

## Qué comprobamos

Se probaron Inicio, subir/bajar volumen y varias reaperturas en el RCA real. Pasaron las 45 pruebas incluidas del teléfono y la comprobación de API de Android lint. No se verificaron horas de uso, encendido desde suspensión, todos los botones ni otros modelos.

La adaptación cubre el recorrido normal del mando; no elimina ni valida todas las funciones avanzadas heredadas. El control por Bluetooth se investigó por separado y no quedó funcionando. El TV conserva su launcher: este fork no instala un inicio estilo Apple TV.

Consulta [LOCAL-RCA.md](LOCAL-RCA.md) para el diagnóstico, cambios, compilación, firmas y límites. [README.md](README.md) conserva la documentación original, precedida por una nota del fork.
