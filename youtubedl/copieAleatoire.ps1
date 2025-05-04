# Nombre de fichiers à copier
$nombreFichiers = 100

# Répertoire de destination
$destination = Join-Path -Path (Get-Location) -ChildPath "CopieFichiersAleatoires"

# Crée le dossier de destination s'il n'existe pas
if (-not (Test-Path -Path $destination)) {
    New-Item -Path $destination -ItemType Directory | Out-Null
}

# Récupère tous les fichiers de manière récursive
try {
    # Récupère tous les fichiers de manière récursive dans le dossier courant
    $fichiers = Get-ChildItem -Path (Get-Location) -Recurse -File -ErrorAction Continue #| Select-Object -First 10
}
catch {
    # Affiche l'erreur s'il y en a une
    Write-Error "Erreur lors de la récupération des fichiers : $_"
    throw
}


# Vérifie qu'il y a des fichiers
if ($fichiers.Count -eq 0) {
    Write-Host "❌ Aucun fichier trouvé."
    return
}


# Sélectionne les fichiers à copier
if ($fichiers.Count -lt $nombreFichiers) {
    Write-Host "⚠️ Seulement $($fichiers.Count) fichiers disponibles. Tous seront copiés."
    $fichiersChoisis = $fichiers
} else {
    $fichiersChoisis = $fichiers | Get-Random -Count $nombreFichiers
}

# Copie les fichiers en gérant les noms en double
foreach ($fichier in $fichiersChoisis) {
    $nomOriginal = $fichier.Name
    $destinationFichier = Join-Path -Path $destination -ChildPath $nomOriginal

    # Si un fichier du même nom existe déjà, on ajoute un suffixe
    $compteur = 1
    while (Test-Path $destinationFichier) {
        $nomSansExt = [System.IO.Path]::GetFileNameWithoutExtension($nomOriginal)
        $extension = [System.IO.Path]::GetExtension($nomOriginal)
        $nouveauNom = "$nomSansExt`_copie$compteur$extension"
        $destinationFichier = Join-Path -Path $destination -ChildPath $nouveauNom
        $compteur++
    }

    # Copie le fichier
    Copy-Item -Path $fichier.FullName -Destination $destinationFichier
}

Write-Host "`n✅ Copie terminée. Fichiers copiés dans : $destination"
