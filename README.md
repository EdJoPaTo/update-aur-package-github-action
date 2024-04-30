# Update AUR package GitHub Action

Update an AUR package to the given tag version.

The git tag has to start with a v which is removed from the tag (`v1.2.3` → `pkgver=1.2.3`).

## Usage

```yaml
    steps:
      - uses: EdJoPaTo/update-aur-package-github-action@main
        with:
          package_name: website-stalker-bin
          ssh_private_key: ${{ secrets.AUR_SSH_PRIVATE_KEY }}
```
