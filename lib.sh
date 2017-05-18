function require_steamcmd() {
    # Download/extract steam
    mkdir -p downloads
    [[ -f downloads/steamcmd.zip ]] || \
        wget http://media.steampowered.com/installer/steamcmd.zip -P downloads
    [[ -f steamcmd.exe ]] || unzip -o downloads/steamcmd.zip
    
    # Install/update steam
    WINEDEBUG=fixme-all wine steamcmd.exe +exit
}

function require_app() {
    # Download app
    [[ -f alienswarm/srcds.exe ]] || \
        WINEDEBUG=fixme-all \
        wine steamcmd.exe \
            +login anonymous \
            +force_install_dir ./alienswarm \
            +app_update 563560 validate \
            +exit
}

function update_app() {
    export WINEDEBUG=fixme-all
    wine steamcmd.exe \
        +login anonymous \
        +force_install_dir \
        ./alienswarm \
        +app_update 563560 \
        +exit
}

function require_config() {
    # Generate INI files
    if [[ ! -f kf2server/KFGame/Config/PCServer-KFGame.ini ]]; then
        wine kf2server/Binaries/Win64/KFServer kf-bioticslab?difficulty=0?adminpassword=secret?gamepassword=secret -port=7777 &
        sleep 20
        kfpid=$(pgrep -f port=7777)
        kill $kfpid
    fi

}

function load_config() {

    ## Load defaults if nothing has been set

    
    # find /path/to/volume -name '*KF-*kfm' | xargs -n 1 basename -s .kfm\n"
    [[ -z "$KF_MAP" ]] && export KF_MAP=KF-BioticsLab       

    # 0 - normal, 1 - hard, 2 - suicidal, 3 - hell on earth
    [[ -z "$KF_DIFFICULTY" ]] && export KF_DIFFICULTY=0

    # Used for web console and in-game logins
    [[ -z "$KF_ADMIN_PASS" ]] && export KF_ADMIN_PASS=secret

    # Setting this creates a private server
    [[ -z "$KF_GAME_PASS" ]] && export KF_GAME_PASS=''

    # 0 - 4 waves, 1 - 7 waves, 2 - 10 waves, default 1
    [[ -z "$KF_GAME_LENGTH" ]] && export KF_GAME_LENGTH=1

    # Name that appears in the server browser
    [[ -z "$KF_SERVER_NAME" ]] && export KF_SERVER_NAME=KF2 Server

    # true or false, default false
    [[ -z "$KF_ENABLE_WEB" ]] && export KF_ENABLE_WEB=false


    ## Now we edit the config files to set the config
    sed -i "s/^GameLength=.*/GameLength=$KF_GAME_LENGTH\r/" /kf2/kf2server/KFGame/Config/PCServer-KFGame.ini
    sed -i "s/^ServerName=.*/ServerName=$KF_SERVER_NAME\r/" /kf2/kf2server/KFGame/Config/PCServer-KFGame.ini
    sed -i "s/^bEnabled=.*/bEnabled=$KF_ENABLE_WEB\r/" /kf2/kf2server/KFGame/Config/KFWeb.ini
}

function launch() {
    export WINEDEBUG=fixme-all
    local cmd

    cmd="wine start /wait alienswarm/srcds.exe "
    cmd+="-game reactivedrop "
    cmd+="-console "
    cmd+="-port 27015 "
    cmd+="+exec server "
    cmd+="+map lobby"

    echo "Running command: $cmd" > $(basename $0)-cmd.log
    $cmd
}

