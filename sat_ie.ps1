$ie = New-Object -com internetexplorer.application
$ie.visible=$true
$url = "https://citas.sat.gob.mx/citasat/agregarcita.aspx"
$ie.navigate($url)

while($ie.Busy) { Start-Sleep -Milliseconds 3000 }
Write-Output "La url: $url ha sido cargada"


$linkEstado = $ie.Document.getElementsByTagName('A') | Where-Object {$_.innerText -eq "Jalisco"}
$linkEstadoStr = $linkEstado.innerText
$linkEstado.click()
Write-Output "El Estado: $linkEstadoStr ha sido Seleccionado"
while($ie.Busy) { Start-Sleep -Milliseconds 3000 }

$linkModulo = $ie.Document.getElementsByTagName('A') | Where-Object {$_.innerText -eq "ADSC Jalisco `"1`" Guadalajara"}
$linkModuloStr = $linkModulo.innerText
$linkModulo.click()
Write-Output "El Modulo: $linkModuloStr ha sido Seleccionado"
while($ie.Busy) { Start-Sleep -Milliseconds 3000 }

# Check e.firma de Personas Físicas
#$serviciosRadio = $ie.Document.getElementsByTagName('input') | ? {$_.type -eq 'radio' -and $_.value -eq '29'}
$serviciosRadio = $ie.Document.getElementsByTagName('input') | ? {$_.type -eq 'radio' -and $_.id -eq 'RBLServicios_4'}
$serviciosRadio.setActive()
$labelServiciosRadio = $ie.Document.getElementsByTagName('label') | ? {$_.htmlFor -eq "RBLServicios_4" }
$labelServiciosRadioStr = $labelServiciosRadio.innerText
$serviciosRadio.click()
Write-Output "El Servicio: $labelServiciosRadioStr ha sido Seleccionado"
while($ie.Busy) { Start-Sleep -Milliseconds 3000 }

$modalHeader = $ie.Document.getElementsByClassName('modal-title') | ? {$_.tagName -eq 'H4'}
$modalHeaderStr = $modalHeader.innerText
IF($modalHeaderStr -match ".*Aviso Importante.*"){
    while($ie.Busy) { Start-Sleep -Milliseconds 3000 }
    Write-Output "Modal Aviso Importante ha sido desplegado"
    $botonModal = $ie.Document.getElementsByTagName('button') | ? {$_.innerText -eq 'Cerrar'}
    $botonModal.click()
    Write-Output "Modal Aviso Importante ha sido cerrado"
}

$labelCaptcha = $ie.Document.getElementsByTagName('label') | ? {$_.innerText -eq "Escriba el código de la imagen *" }
$labelCaptchaStr = $labelCaptcha.innerText


$labelNombreContribuyente = $ie.Document.getElementsByTagName('label') | ? {$_.id -eq "LabelSolicitarNombreContribuyente2" }
$labelNombreContribuyenteStr = $labelNombreContribuyente.innerText

#While($labelCaptchaStr.length -gt 0 -or $labelCaptchaStr -match ".*Escriba el código de la imagen.*" ){
While($labelNombreContribuyenteStr.length -le 0){
    Write-Output "Ingrese manualmente el codigo anti-spam"

    [void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
    $title = 'AntiSpam'
    $msg   = 'Escriba el código de la imagen *:'
    $text = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)
    $spamInput = $ie.Document.getElementsByTagName('INPUT') | ? {$_.id -eq "txtUserInput" }
    $spamInput.value = $text
    Write-Output "Codigo ingresado $text"

    $buttonSiguiente = $ie.Document.getElementsByTagName('INPUT') | ? {$_.name -eq "cmdSiguiente" }
    $buttonSiguiente.click()

    while($ie.Busy) { Start-Sleep -Milliseconds 3000 }
    # Update Variable
    $LabelNombreContribuyente = $ie.Document.getElementsByTagName('label') | ? {$_.id -eq "LabelSolicitarNombreContribuyente2" }
    $labelNombreContribuyenteStr = $labelNombreContribuyente.innerText
}

$LabelNombreContribuyente = $ie.Document.getElementsByTagName('label') | ? {$_.id -eq "LabelSolicitarNombreContribuyente2" }
IF ($LabelNombreContribuyente.innerText.length -gt 0){
    Write-Output "Datos de contribuyente llenados"
    $NombreContribuyente = $ie.Document.getElementsByTagName('INPUT') | ? {$_.id -eq "TXTNombreContribuyente" }
    $NombreContribuyente.value = "Nombre de Prueba"

    $RFC = $ie.Document.getElementsByTagName('INPUT') | ? {$_.id -eq "TXTRFC" }
    $RFC.value = "BEVJ950826MV2"

    $CorreoElectronico = $ie.Document.getElementsByTagName('INPUT') | ? {$_.id -eq "TXTCorreoElectronico" }
    $CorreoElectronico.value = "sample@gmail.com"

    $buttonSubmit = $ie.Document.getElementsByTagName('INPUT') | ? {$_.id -eq 'cmdSolicitarCita'}
    $buttonSubmit.click()
    Write-Output "Formulario enviado"
    while($ie.Busy) { Start-Sleep -Milliseconds 3000 }

    # Busqueda de disponibilidad

    # Rojo - Sin disponibilidad rgb(208, 2, 27)
    # Azul  - Alta disponibilidad rgb(74,144,226)
    # Beige - Poca disponibilidad rgb(250,235,204)
    # $celdas_nodisponibles = $ie.Document.getElementsByTagName('TD') | ? {$_.outerHTML -match "rgb\(208, 2, 27\)" }

 
    DO{
        Write-Output "Busqueda de disponibilidad"
        while($ie.Busy) { Start-Sleep -Milliseconds 3000 }
        $celdas = $ie.Document.getElementsByTagName('TD') | ? {$_.outerHTML -match "rgb\(250, 235, 204\)|rgb\(74,144,226\)" }

        $delay = 30
        $Counter_Form = New-Object System.Windows.Forms.Form
        $Counter_Form.Text   = "Countdown Timer!"
        $Counter_Form.Width  = 400
        $Counter_Form.Height = 80
        $Counter_Form.StartPosition = 'CenterScreen'

        $Counter_Label = New-Object System.Windows.Forms.Label
        $Counter_Label.AutoSize = $true
        $Counter_Label.Font = 'Microsoft Sans Serif,20'

        $Counter_Form.Controls.Add($Counter_Label)
        while ($delay -ge 0){
          $Counter_Form.Show()
          $Counter_Label.Text = "Segundos para refrescar: $($delay)"
          start-sleep -Seconds 1
          $delay -= 1
        }
<#         $ieSet = (New-Object -ComObject Shell.Application).Windows() |  ? {$_.LocationUrl -like "https://citas.sat.gob.mx/citasat/*"}
        $ieSet.Refresh()
        Write-Output "Pagina refrescada" #>
        $buttonSubmit = $ie.Document.getElementsByTagName('INPUT') | ? {$_.id -eq 'cmdSolicitarCita'}
        $buttonSubmit.click()
        Write-Output "Formulario enviado"
        while($ie.Busy) { Start-Sleep -Milliseconds 3000 }
        $Counter_Form.Close()
    }UNTIL($celdas.length -gt 0)

    IF($celdas.length -gt 0){
        [System.Windows.MessageBox]::Show('Actualmente hay dias en el calendario con disponibilidad','Info')
    }
}
