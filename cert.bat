@rem Generate valid CA
"C:\Users\prashant\Desktop\zipdir\openssl\Lib\x64\RELEASE\bin\openssl.exe" genrsa -passout pass:1234 -des3 -out ca.key 4096
"C:\Users\prashant\Desktop\zipdir\openssl\Lib\x64\RELEASE\bin\openssl.exe" req -passin pass:1234 -new -x509 -days 365 -key ca.key -out ca.crt -subj  "/C=SP/ST=Spain/L=Valdepenias/O=Test/OU=Test/CN=Root CA"

@rem Generate valid Server Key/Cert
"C:\Users\prashant\Desktop\zipdir\openssl\Lib\x64\RELEASE\bin\openssl.exe" genrsa -passout pass:1234 -des3 -out server.key 4096
"C:\Users\prashant\Desktop\zipdir\openssl\Lib\x64\RELEASE\bin\openssl.exe" req -passin pass:1234 -new -key server.key -out server.csr -subj  "/C=SP/ST=Spain/L=Valdepenias/O=Test/OU=Server/CN=localhost"
"C:\Users\prashant\Desktop\zipdir\openssl\Lib\x64\RELEASE\bin\openssl.exe" x509 -req -passin pass:1234 -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt

@rem Remove passphrase from the Server Key
"C:\Users\prashant\Desktop\zipdir\openssl\Lib\x64\RELEASE\bin\openssl.exe" rsa -passin pass:1234 -in server.key -out server.key

@rem Generate valid Client Key/Cert
"C:\Users\prashant\Desktop\zipdir\openssl\Lib\x64\RELEASE\bin\openssl.exe" genrsa -passout pass:1234 -des3 -out client.key 4096
"C:\Users\prashant\Desktop\zipdir\openssl\Lib\x64\RELEASE\bin\openssl.exe" req -passin pass:1234 -new -key client.key -out client.csr -subj  "/C=SP/ST=Spain/L=Valdepenias/O=Test/OU=Client/CN=localhost"
"C:\Users\prashant\Desktop\zipdir\openssl\Lib\x64\RELEASE\bin\openssl.exe" x509 -passin pass:1234 -req -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out client.crt

@rem Remove passphrase from Client Key
"C:\Users\prashant\Desktop\zipdir\openssl\Lib\x64\RELEASE\bin\openssl.exe" rsa -passin pass:1234 -in client.key -out client.key


https://gist.github.com/bitoiu/9e19962b991a71165268

[ v3_req ]
 
# Extensions to add to a certificate request
 
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
Add the main hostname and the wildcard to a new [alt_names] section

[alt_names]
DNS.1 = yourdomain.com
DNS.2 = *.yourdomain.com
For example, for octodmeo.com

[alt_names]
DNS.1 = octodemo.com
DNS.2 = *.o

openssl genrsa -out hostname.key 2048
openssl rsa -in hostname.key -out hostname-key.pem
openssl req -new -key hostname-key.pem -out hostname-request.csr
openssl x509 -req -extensions v3_req -days 365 -in hostname-request.csr -signkey hostname-key.key -out hostname-cert.pem -extfile <path to openssl.conf>
