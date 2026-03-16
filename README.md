# CoreOS Package Repository

Binary package repository for CoreOS. Packages are built automatically via GitHub Actions and served via GitHub Pages.

## Repository URL

```
https://frank1o3.github.io/CoreOS-repo/x86_64
```

## Adding this repo to pacman

```ini
# /etc/pacman.conf
[coreos]
SigLevel = Required DatabaseOptional
Server = https://frank1o3.github.io/CoreOS-repo/x86_64
```

Then import the signing key:
```bash
curl -O https://frank1o3.github.io/CoreOS-repo/coreos-repo.gpg
sudo pacman-key --add coreos-repo.gpg
sudo pacman-key --lsign-key <KEY_ID>
```

---

## First-time setup

### 1. Generate your GPG signing key

Run this on your local machine:

```bash
gpg --full-gen-key
# Choose: RSA and RSA
# Key size: 4096
# Expiry: 0 (no expiry)
# Name: CoreOS Packages
# Email: your GitHub email
```

Export your key ID:
```bash
gpg --list-secret-keys --keyid-format LONG
# Note the ID after rsa4096/ — e.g. ABCD1234EFGH5678
```

Export private key for GitHub Actions:
```bash
gpg --armor --export-secret-keys ABCD1234EFGH5678
```

### 2. Add GitHub secret

Go to your repo → Settings → Secrets and variables → Actions → New secret:

- Name: `COREOS_GPG_PRIVATE_KEY`
- Value: paste the entire `--BEGIN PGP PRIVATE KEY BLOCK--` output

### 3. Enable GitHub Pages

Go to repo → Settings → Pages:
- Source: Deploy from branch
- Branch: `gh-pages` / `/ (root)`

---

## Adding a new package

```bash
./scripts/new-package.sh <pkgname> <github-url>
```

Then edit the generated PKGBUILD, commit, and tag to release:

```bash
git tag modforge-cli-v1.2.0
git push --tags
```

The GitHub Action builds, signs, and publishes automatically.

---

## Repository structure

```
CoreOS-repo/
├── .github/
│   └── workflows/
│       └── build-package.yml   ← Auto build + publish on tag push
├── packages/
│   └── modforge-cli/
│       └── PKGBUILD            ← Package recipe
├── scripts/
│   └── new-package.sh          ← Helper to scaffold new packages
└── README.md
```

The `gh-pages` branch (auto-managed by GitHub Actions) contains:
```
x86_64/
├── coreos.db.tar.gz            ← Package database
├── coreos.db                   ← Symlink
├── coreos.files.tar.gz         ← File index
├── coreos.files                ← Symlink
└── *.pkg.tar.zst               ← Built packages + .sig files
coreos-repo.gpg                 ← Public signing key
```
