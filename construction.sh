#!/bin/bash

# Ce script doit être exécuté en tant que root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Ce script doit être exécuté en tant que root."
  exit 1
fi

# === UTILISATEUR JOUEUR ET GROUPE ===

# Crée le groupe du joueur (si pas déjà existant)
groupadd -f ctfplayer

# Crée l'utilisateur joueur et son home
id joueur &>/dev/null || useradd -m -G ctfplayer joueur
echo "joueur:joueur" | chpasswd
# === FLAG 1 ===

echo "📁 Création du flag 1..."

# Flag à cacher
flag_1="FLAG{Nadhir_"

# Dossier de travail
mkdir -p /home/ctf/flag_1
cd /home/ctf/flag_1 || exit

# Génération d'une structure aléatoire
random_dossier_num=$((RANDOM % 10 + 1))
random_sous_num=$((RANDOM % 10 + 1))
random_sous_sous_num=$((RANDOM % 10 + 1))

for i in {1..10}; do
  dossier="dossier_$i"
  mkdir -p "$dossier"

  for j in {1..10}; do
    sous_dossier="$dossier/dossier_$j"
    mkdir -p "$sous_dossier"

    for l in {1..10}; do
      sous_sous_dossier="$sous_dossier/dossier_$l"
      mkdir -p "$sous_sous_dossier"

      # Génère un nom de fichier aléatoire
      fichier_random=$(tr -dc a-z0-9 </dev/urandom | head -c 8)
      fichier_path="$sous_sous_dossier/$fichier_random.txt"

      # Place le flag au bon endroit
      if [[ $i -eq $random_dossier_num && $j -eq $random_sous_num && $l -eq $random_sous_sous_num ]]; then
        echo -e "$flag_1" > "$fichier_path"
      else
        echo "juste un fichier vide" > "$fichier_path"
      fi
    done
  done
done

# Donne les droits au joueur
chown -R joueur:ctfplayer /home/ctf/flag_1

# === FLAG 2 ===

echo "🔐 Création du flag 2..."

mkdir -p /home/ctf/flag_2
cd /home/ctf/flag_2 || exit

# Crée l'utilisateur 'alice' avec son home
id alice &>/dev/null || useradd -m alice

# Journal avec l'indice
echo "Bonjour, je suis Alice et j'ai volé le morceau de Flag que vous cherchez ! Je l'ai caché chez moi mais il n'y a que moi qui ai la clé pour rentrer là-bas." > journal.txt
chmod 644 journal.txt

# Flag protégé
echo "FLAG{Soren}" > secret_flag.txt
chmod 600 secret_flag.txt
chown alice:alice secret_flag.txt

# Script pour "devenir alice"
echo -e "#!/bin/bash\nsu - alice" > run_as_alice.sh
chmod 700 run_as_alice.sh
chown root:root run_as_alice.sh

# Ajout dans sudoers : le joueur peut exécuter le script sans mot de passe
echo "joueur ALL=(ALL) NOPASSWD: /home/ctf/flag_2/run_as_alice.sh" > /etc/sudoers.d/ctf_clue
chmod 440 /etc/sudoers.d/ctf_clue

# === ENV VAR POUR FLAG 2 ===

# Petite touche bonus : ajouter une variable d'environnement utile dans le shell du joueur
echo "export FLAG_PATH=/home/ctf/flag_2" >> /home/joueur/.bashrc
chown joueur:joueur /home/joueur/.bashrc

echo "✅ Challenge installé avec succès !"
echo "➡️ Connecte-toi en tant qu'utilisateur joueur et rend toi dans le répertoire /home/ctf pour commencer"
