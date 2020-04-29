# ansible-role-ssl-certificate

Manage a SSL certificate on a server

## Testing

Testing requires Molecule and Docker 

## Role Variables

### defaults
| Variable                         | Choices/Defaults | Comments                                       |
| :------------------------------- | :--------------- | :--------------------------------------------- |
| ssl_certificate_source_path      | certs            | path under files to search for certificates    |
| ssl_certificate_path             | /etc/ssl/private | Where to store the certificates                |
| ssl_certificate_path_owner       | root             | User to own the path                           |
| ssl_certificate_path_group       | root             | Group to own the path                          |
| ssl_certificate_path_mode        | 0700             | Path mode                                      |
| ssl_certificate_owner            | root             | User to own the cert                           |
| ssl_certificate_group            | root             | Group to own the cert                          |
| ssl_certificate_mode             | 0440             | Cert mode                                      |
| ssl_certificate_files            |                  | List of files to copy                          |

### ssl_certificate_files

This is an array of dictionaries, that define the local file and the destination file

```yaml
ssl_certificate_files_default:
  - file: server.crt
    dest: "{{ ssl_certificate_name }}.crt"
  - file: ca.crt
    dest: "{{ ssl_certificate_name }}-ca.crt"
  - file: server.key
    dest: "{{ ssl_certificate_name }}.key"
```

If you want to copy over a specific file (ie - server.pfx) you would add 
```yaml
ssl_certificate_files_extra:
  - file: server.pfx
    dest: "{{ ssl_certificate_name }}.pfx"
```

## License

MIT

## Author Information

[David Lundgren](https://www.davidscode.com)