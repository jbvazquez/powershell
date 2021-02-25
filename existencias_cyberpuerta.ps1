##########################################################################
# Created: 2021/01/21 13:20:01
# Last modified: 2021/02/25 14:10:40
# File   : existencias_cyberpuertta.ps1
# Author : Jose Becerra
# Description : Este script hace una solictiud a la pagina del producto en cyberpuerta
# Si no existe la clase "emdetails_notinstocktext1" usada en divs para productos agotados
# desplegar una notificacion
#
# Example: Usage: existencias_cyberpuertta.ps1
#
# Change History
# Date          Author      			Version    	Description of Change
# 2021/01/21    Jose Becerra			1.0.0		Initial Release
# 2021/02/21    Jose Becerra			1.0.1		New div validation text
###########################################################################
function MessageDialogUrl {
    param (
        $message,
        $productName,
        $url
    )

    Add-Type -AssemblyName PresentationFramework
    $msgBoxInput = [System.Windows.MessageBox]::Show("$message `n`n$productName `n`n$url `n`nAbrir Enlace" , 'Info', 'YesNoCancel', 'Info')
    switch ($msgBoxInput) {

        'Yes' {

            ## Do something 
            [system.Diagnostics.Process]::Start("chrome", $url)

        }

        'No' {

            ## Do something
            Exit

        }
    }
    
}
function Check-Stock {
    #$url = "https://www.cyberpuerta.mx/Computo-Hardware/Componentes/Tarjetas-de-Video/Tarjeta-de-Video-Asus-NVIDIA-GeForce-GTX-1050-Ti-Phoenix-4GB-128-bit-GDDR5-PCI-Express-3-0.html"
    $url = "https://www.cyberpuerta.mx/Computo-Hardware/Componentes/Tarjetas-de-Video/Tarjeta-de-Video-AORUS-NVIDIA-GeForce-RTX-3070-Master-8GB-256-bit-GDDR6-PCI-Express-x16-4-0.html"
    #$url = "https://www.cyberpuerta.mx/Computo-Hardware/Componentes/Tarjetas-de-Video/Tarjeta-de-Video-PNY-NVIDIA-Quadro-RTX-8000-48GB-GDDR6-PCI-Express-x16-3-0.html"
    Try {
        $WebResponse = Invoke-WebRequest $url
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        #Send-MailMessage -From ExpensesBot@MyCompany.Com -To WinAdmin@MyCompany.Com -Subject "HR File Read Failed!" -SmtpServer EXCH01.AD.MyCompany.Com -Body "We failed to read file $FailedItem. The error message was $ErrorMessage"
       
        $message = "No hay conexion a internet, $ErrorMessage, $FailedItem"
        $msgBoxInput = [System.Windows.MessageBox]::Show("$message `n`n$productName" , 'Error')   
        Break
    }
 
    if ($WebResponse.StatusCode -eq 200) {

        $ParsedHtml = $WebResponse.ParsedHtml
        $emdetails_notinstocktext1 = $ParsedHtml.body.getElementsByClassName("emdetails_notinstocktext1")
        $eol_txt_1 = $ParsedHtml.body.getElementsByClassName("eol_txt_1")[0].innerText
        $eol_txt_3 = $ParsedHtml.body.getElementsByClassName("eol_txt_3")[0].innerText
    
        $products = $ParsedHtml.body.getElementsByClassName("detailsInfo_right_title")
        $productName = $products[0].innerHTML.ToString()

        if ($emdetails_notinstocktext1.length -ge 1 -or $eol_txt_1 -match "(?=.*no)(?=.*existencia)" -or $eol_txt_3 -match "(?=.*no)(?=.*existencia)") {
            $message = "No hay existencias"
            MessageDialogUrl($message, $productName, $url)
        }
        else {
            $message = "Si hay existencias"
            MessageDialogUrl($message, $productName, $url)
        }
    }
}
#$NoStockDivs | foreach {write-host $_.textContent}
#$NoStockDivs.length
Check-Stock