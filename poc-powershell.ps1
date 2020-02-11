[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Function Get-Token
{
    [CmdletBinding()]

    $body = @{
        client_id = $Env:auth0_clientid
        client_secret = $Env:auth0_clientSecret
        grant_type = "client_credentials"
        audience = "https://dev-iqbfcaun.eu.auth0.com/api/v2/"
    };

    try
    {
        Write-Host @body;
        
        $response = Invoke-RestMethod -Uri $Env:auth0_url -Method Post -ContentType "application/json" -Body $body;

        Write-Output $response;
        
        $token = $response.access_token;
        
        Write-Output $token;
        
        return $token;
    }
    catch
    {
        $result = $_.Exception.Response.GetResponseStream();
        $reader = New-Object System.IO.StreamReader($result);
        $reader.BaseStream.Position = 0;
        $reader.DiscardBufferedData();
        $responseBody = $reader.ReadToEnd() | ConvertFrom-Json;
        Write-Host "ERROR: $($responseBody.error)";
        return;
    }
}

Get-Token
