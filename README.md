# PowerShell
PowerShell Scripts

 - existencias_cyberpuerta.ps1

## existencias_cyberpuerta.ps1
Script para verificar la existencia de un producto, obtiene el contenido de la pagina del producto en www.cyberpuerta.com
Si no existe algún objeto con la clase `class="emdetails_notinstocktext1"` despliega una notificación.
- Ejemplos: 
```html 
<div class="emdetails_notinstocktext1">Lo sentimos, por el momento este producto está agotado.</div>
```

```html 
<div class="eol_txt_1">Lo sentimos, este producto no cuenta con existencias desde hace varias semanas.</div>
```

```html
<div class="eol_txt_3">Es probable que se encuentre fuera del mercado y no volvamos a tener existencia, así que te recomendamos revisar la categoría para encontrar otra alternativa.</div>
```

>Estas clases son usada para productos agotados o sin existencia.
### No Existencia MessageBox
![Info MessageBox](https://github.com/jbvazquez/powershell/blob/main/images/no_existencia.png?raw=true)

### Existencia MessageBox
![Info MessageBox](https://github.com/jbvazquez/powershell/blob/main/images/si_existencia.png?raw=true)

### Error de conexión MessageBox
![Info MessageBox](https://github.com/jbvazquez/powershell/blob/main/images/no_internet.png?raw=true)

### Verificación periódica automática

- **Windows**: 
Para realizar la verificación en un intervalo especifico de tiempo se puede crear una tarea en [Task Scheduler](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/schtasks).
Tutorial: [How to Automate PowerShell Scripts with Task Scheduler](https://blog.netwrix.com/2018/07/03/how-to-automate-powershell-scripts-with-task-scheduler/)
- **Linux**:
Para realizar la ejecución periódica del script se puede implementar [crontab](https://man7.org/linux/man-pages/man5/crontab.5.html)
 