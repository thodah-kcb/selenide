[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Function Get-Token
{
    [CmdletBinding()]

    $body = @{
        client_id = $Env:clientid
        client_secret = $Env:clientSecret
        grant_type = "client_credentials"
        audience = "https://dev-iqbfcaun.eu.auth0.com/api/v2/"
    };

    try
    {
        Write-Host "THIS IS A SECRET: $(auth0_url)"
        
        Write-Host @body
        
        $response = Invoke-RestMethod -Uri $Env:url -Method Post -ContentType "application/json" -Body ($body|ConvertTo-Json);
        $token = $response.access_token;
        return $token;
    }
    catch
    {
        $result = $_.Exception.Response.GetResponseStream();
        $reader = New-Object System.IO.StreamReader($result);
        $reader.BaseStream.Position = 0;
        $reader.DiscardBufferedData();
        $responseBody = $reader.ReadToEnd() | ConvertFrom-Json;
        
        Write-Host "ERROR: $($responseBody.error)"
        
        return;
    }
}

Get-Token
