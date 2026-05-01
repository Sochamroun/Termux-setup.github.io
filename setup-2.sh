#!/data/data/com.termux/files/usr/bin/bash

echo "Starting Termux Setup install software..."

# update 
yes | pkg update && yes | pkg upgrade

# Install packages
yes | pkg install python ffmpeg git tmux wget unzip iproute2 libqrencode cloudflared fish nodejs net-tools nano -y

# Install pip tools
pip install --upgrade pip
pip install flask yt-dlp pyftpdlib

# Fix fish config folder (important)
mkdir -p ~/.config/fish

# Set fish shell (safe)
chsh -s fish || echo "⚠️ Cannot change shell (ignore if error)"

# Fix PATH
grep -qxF 'set -U fish_user_paths $fish_user_paths $HOME' ~/.config/fish/config.fish || \
echo 'set -U fish_user_paths $fish_user_paths $HOME' >> ~/.config/fish/config.fish

# ---------------- VIDEO SCRIPT ----------------
cat > ~/video.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

DOWNLOAD_FOLDER="/storage/emulated/0/Movies"
mkdir -p "$DOWNLOAD_FOLDER"

echo "🎬 Multi Video Downloader (CTRL+C to exit)"

while true; do
    read -p "Enter video URL: " url

    if [[ -z "$url" ]]; then
        echo "⚠️ No URL entered"
        continue
    fi

    echo "⬇️ Downloading $url ..."

    yt-dlp \
        -f "bestvideo[height<=720][ext=mp4][fps<=60]+bestaudio[ext=m4a]/mp4" \
        --merge-output-format mp4 \
        -S "vcodec:h264,lang,quality,res,fps,hdr:12,acodec:aac" \
        -o "$DOWNLOAD_FOLDER/%(title)s.%(ext)s" \
        "$url" &

    echo "✅ Started!"
done
EOF

chmod +x ~/video.sh

# ---------------- AUDIO SCRIPT ----------------
cat > ~/song.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

DOWNLOAD_FOLDER="/storage/emulated/0/Music"
mkdir -p "$DOWNLOAD_FOLDER"

echo "🎵 Multi Audio Downloader (CTRL+C to exit)"

while true; do
    read -p "Enter video URL: " url

    if [[ -z "$url" ]]; then
        echo "⚠️ No URL entered"
        continue
    fi

    echo "⬇️ Downloading audio..."

    yt-dlp -x \
        --audio-format mp3 \
        --audio-quality 256k \
        --embed-thumbnail \
        --add-metadata \
        -o "$DOWNLOAD_FOLDER/%(title)s.%(ext)s" "$url" &

    echo "🎧 Started!"
done
EOF

chmod +x ~/song.sh

# ---------------- FTP SERVER ----------------
cat > ~/ftp.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

cd /storage/emulated/0 || exit

echo "📡 FTP Server Running"
echo "Port: 2121"
echo "User: user | Password: 12345"

python -m pyftpdlib -p 2121 -u user -P 12345 -d /storage/emulated/0 -w
EOF

chmod +x ~/ftp.sh

##Emm

echo ""
echo "✅ Setup Complete!"
echo "--------------------------------"
echo "Commands (use this to show files)"
echo "video.sh   → Download videos 🎬"
echo "song.sh    → Download audio 🎵"
echo "ftp.sh     → Start FTP server 📡""

