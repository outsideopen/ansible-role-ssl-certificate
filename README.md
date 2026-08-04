# ansible-role-ssl-certificate

Manage a SSL certificate on a server

## Installation

```ansible-galaxy install outsideopen.ssl_certificate```

### Example

```yaml
---
- hosts: webserver
  roles:
    - role: outsideopen.ssl_certificate
      # the certs should be located in files/certs/example_com/
      # named as server.crt, ca.crt and server.key
      ssl_certificate_name: example_com
```

## Role Variables

### defaults

| Variable                         | Choices/Defaults                                                   | Comments                                                                                                   |
|:---------------------------------|:-------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------|
| ssl_certificate_create_fullchain |                                                                    | Whether to create a full chain file as `{name}-full.pem`. Primarily useful for nginx                      |
| ssl_certificate_files            | `ssl_certificate_files_default` + `ssl_certificate_files_extra`    | List of files to copy                                                                                      |
| ssl_certificate_files_default    | [see below](#ssl_certificate_files)                                | Default list of files to copy                                                                              |
| ssl_certificate_files_extra      | `[]`                                                               | List of extra files to copy                                                                                |
| ssl_certificate_group            | root                                                               | Group to own the cert                                                                                      |
| ssl_certificate_mode             | 0440                                                               | Cert mode                                                                                                  |
| ssl_certificate_notify           | `[]`                                                               | List of handlers that should be notified on a change                                                       |
| ssl_certificate_owner            | root                                                               | User to own the cert                                                                                       |
| ssl_certificate_path             | /etc/ssl/private                                                   | Where to store the certificates                                                                            |
| ssl_certificate_path_cert        | `{ssl_certificate_path}/{ssl_certificate_name}`                    | Full certificate path                                                                                      |
| ssl_certificate_path_group       | root                                                               | Group to own the path                                                                                      |
| ssl_certificate_path_mode        | 0700                                                               | Path mode                                                                                                  |
| ssl_certificate_path_owner       | root                                                               | User to own the path                                                                                       |
| ssl_certificate_source_path      | certs                                                              | path under files to search for certificates                                                                |
| ssl_certificate_cert_content     | contents of `{ssl_certificate_source_path}/{name}/server.crt`      | Certificate data used for the default cert file and the full chain; override to supply the data directly  |
| ssl_certificate_key_content      | contents of `{ssl_certificate_source_path}/{name}/server.key`      | Private key data used for the default key file; override to supply the data directly                      |
| ssl_certificate_ca_content       | contents of `{ssl_certificate_source_path}/{name}/ca.crt`, if any  | CA data used for the default ca file and the full chain; override to supply the data directly              |

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

#### Supplying data

If you are pulling the key, or cert, from a password management system (1Password or Bitwarden), you may want to supply
the actual content instead of having a copy of the files on your system.

The simplest way is to override the `ssl_certificate_cert_content`, `ssl_certificate_key_content` and
`ssl_certificate_ca_content` variables, which back the default cert/key/ca files and the full chain:

```yaml
ssl_certificate_cert_content: "{{ lookup('community.general.bitwarden', 'example.com', field='cert') | first }}"
ssl_certificate_key_content: "{{ lookup('community.general.onepassword', 'example.com', field='private_key') }}"
ssl_certificate_ca_content: "{{ lookup('community.general.bitwarden', 'example.com', field='ca') | first }}"
```

For extra files, or to fully replace `ssl_certificate_files_default`, each entry accepts `content` in place of `file`:

```yaml
ssl_certificate_files_extra:
  - content: "{{ lookup('community.general.bitwarden', 'example.com', field='cert') | first }}"
    dest: "{{ ssl_certificate_name }}.pem"
  - content: "{{ lookup('community.general.onepassword', 'example.com', field='private_key') }}"
    dest: "{{ ssl_certificate_name }}.key"
```

## Testing

Testing requires Molecule and Docker

```
pipenv shell
pip install -r molecule/requirements.txt
molecule test
```

## License

MIT

## Author Information

[David Lundgren](https://www.davidscode.com)