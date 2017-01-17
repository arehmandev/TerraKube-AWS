output "capem" {
  value = "${tls_self_signed_cert.ca.cert_pem}"
}

output "cakey" {
  value = "${tls_private_key.ca.private_key_pem}"
}
