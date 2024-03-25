#!/bin/zsh
if [ ! -t 1 ]; then
  # For pipe stdout
  if [ ! -t 0 ]; then
    # For pipe in and pipe out
    echo $(kitten icat --print-window-size):$COLUMNS > /tmp/ca.stdin.info
    pee \
      'head > /tmp/ca.stdin.file
        echo $(exiftool -s3 -MIMEType /tmp/ca.stdin.file )$(file -Lb --mime-type /tmp/ca.stdin.file).\
          $(exiftool -s2 /tmp/ca.stdin.file | grep -n "FileTypeExtension:" | sed "s/.*FileTypeExtension: //") \
        >>/tmp/ca.stdin.info
      '\
      'sleep 3
        CATY=$( tail -1 /tmp/ca.stdin.info )
        DSIZE=$( head -1 /tmp/ca.stdin.info )
        # echo $CATY >/dev/tty
        if [[ "$CATY" == *video* ]]; then
          mpv --vo=kitty --loop-file=inf -vo-kitty-top=10 -vo-kitty-left=$(( $(echo $DSIZE |  sed "s/.*://" )/2 -25 ))\
            --term-status-msg= --vo-kitty-width=800 --vo-kitty-height=800 --vo-kitty-alt-screen=no - >/dev/tty
        elif [[ "$CATY" == *audio* ]]; then
          mpv --vo=kitty --loop-file=inf -vo-kitty-top=5 -vo-kitty-left=$(( $(echo $DSIZE |  sed "s/.*://" )/2 -25 ))\
            --term-status-msg= --vo-kitty-width=800 --vo-kitty-height=800 --vo-kitty-alt-screen=no - >/dev/tty
        elif [[ "$CATY" == *image* ]]; then
          timg -ICU --title=STDIN:%wx%h - >/dev/tty
        elif [[ "$CATY" == *json* ]]; then
          jq --color-output >/dev/tty
        elif [[ "$CATY" == *text* ]]; then
          if [[ "$CATY" == *.txt ]]; then
            bat -l python --paging=never --style=header,snip,grid - >/dev/tty
          else
            bat --paging=never --style=header,snip,grid - >/dev/tty
          fi
        else
          cat >/tmp/ca.stdin.file
          echo "Unable to Sream in Realtime" >>/tmp/ca.stdin.info
        fi
      '\
      'sleep 3
        CATY=$( tail -1 /tmp/ca.stdin.info )
        # echo $CATY >/dev/tty
        if [[ "$CATY" == *json* ]]; then
          jq >/dev/stdout
        else
          cat >/dev/stdout
        fi
      '
      if [[ "$(tail -1 /tmp/ca.stdin.info)" == "Unable to Sream in Realtime" ]]; then
        sca /tmp/ca.stdin.file
      fi
    return
  else
    # For non pipe in but pipe out
    if [[ "$( file -Lb --mime-type "$1")" == *json* ]]; then
      jq ${@:1:-1} . < "${@: -1}" > /dev/stdout
    else
      cat $@ >/dev/stdout
    fi
    return
  fi
elif [ ! -t 0 ]; then
  # For pipe in but not pipe out
  echo $(kitten icat --print-window-size):$COLUMNS > /tmp/ca.stdin.info
  pee \
    'head > /tmp/ca.stdin.file
      echo $(exiftool -s3 -MIMEType /tmp/ca.stdin.file )$(file -Lb --mime-type /tmp/ca.stdin.file)\
        .$(exiftool -s2 /tmp/ca.stdin.file | grep -n "FileTypeExtension:" | sed "s/.*FileTypeExtension: //") \
      >>/tmp/ca.stdin.info
    '\
    'sleep 3
      CATY=$( tail -1 /tmp/ca.stdin.info )
      DSIZE=$( head -1 /tmp/ca.stdin.info )
      # echo $CATY >/dev/tty
      if [[ "$CATY" == *video* ]]; then
        mpv --vo=kitty --loop-file=inf -vo-kitty-top=10 -vo-kitty-left=$(( $(echo $DSIZE |  sed "s/.*://" )/2 -25 ))\
          --term-status-msg= --vo-kitty-width=800 --vo-kitty-height=800 --vo-kitty-alt-screen=no - >/dev/tty
      elif [[ "$CATY" == *audio* ]]; then
        mpv --vo=kitty --loop-file=inf -vo-kitty-top=5 -vo-kitty-left=$(( $(echo $DSIZE |  sed "s/.*://" )/2 -25 ))\
          --term-status-msg= --vo-kitty-width=800 --vo-kitty-height=800 --vo-kitty-alt-screen=no - >/dev/tty
      elif [[ "$CATY" == *image* ]]; then
        timg -ICU --title=STDIN:%wx%h - >/dev/tty
      elif [[ "$CATY" == *json* ]]; then
        jq --color-output >/dev/tty
      elif [[ "$CATY" == *text* ]]; then
        if [[ "$CATY" == *.txt ]]; then
          bat -l python --paging=never --style=header,snip,grid - >/dev/tty
        else
          bat --paging=never --style=header,snip,grid - >/dev/tty
        fi
      else
        cat >/tmp/ca.stdin.file
        echo "Unable to Sream in Realtime" >>/tmp/ca.stdin.info
      fi
    '
    if [[ "$(tail -1 /tmp/ca.stdin.info)" == "Unable to Sream in Realtime" ]]; then
      sca /tmp/ca.stdin.file
    fi
  return 1
elif [[ $# -eq 0 ]]; then
    eza --icons --classify --git --group-directories-first
    return
fi
# Arguments
ARG=""
# Errors
ERR=""
while [[ $# -gt 0 ]]; do
  if [[ "$1" == -* ]]; then
    # If an flag then saving it to ARG
    ARG=$ARG" "$1
  elif [ ! -e "$1" ]; then
    # Checking if file exits or not
    ERR=$ERR$1", "
    ARG=""
  else
    case "$(echo $( exiftool -s2 $1 | grep -m 1 -n 'MIMEType:' | sed 's/.*MIMEType: //')+:$(file -Lb $1):+$(
          if [[ "$( exiftool -s2 $1 | grep -n 'FileTypeExtension:' | sed 's/.*FileTypeExtension: //' )" != "" ]]; then
            echo ".$(exiftool -s2 $1 | grep -n 'FileTypeExtension:' | sed 's/.*FileTypeExtension: //')"
          fi
      ) | awk '{print tolower($0)}')" in

      *+:directory:+*)
        if [[ $ARG == "" ]]; then
          ARG="-lah --icons --tree --level=3 --git"
        fi
        eza $(echo $ARG) $1
        ARG=""
      ;;

      *.html)
        awrit "file://$(realpath $@)"
      ;;

      text*)
        if [[ $ARG == "" ]]; then
            ARG="--paging=never --style=header-filename,header,header-filesize,snip,grid"
        fi
        bat $(echo $ARG) $1
        ARG=""
      ;;

      *.json*)
        if [[ "$1" == *.ipynb ]]; then
          if [[ $ARG == "" ]]; then
            ARG=""
          fi
            euporie-preview $(echo $ARG) $1
        else
          if [[ $ARG == "" ]]; then
            ARG="-C"
          fi
            jq $(echo $ARG) . < "$1"
        fi
        ARG="" 
      ;;

      *.eps)
        kitten icat "$1"
        if [[ $ARG == "" ]]; then
          ARG="-c"
        fi
        nvimpager $(echo $ARG) $1
        ARG=""
      ;;

      *.svg)
        kitten icat "$1"
        if [[ $ARG == "" ]]; then
          ARG="--paging=never --style=header-filename,header,header-filesize,snip,grid"
        fi
        bat $(echo $ARG) $1
        ARG=""
      ;;

      video* |\
      *.mpeg | *.ogv | *.mkv | *.mpg | *.vob | *.ts | *.m2v | *.dat | *.mov | *.as[fx] | *.fl[icv] |\
      *.webm | *.avi | *.3gp | *.mp4 | *.m4v | *.qt | *.mts | *.wmv | *.gif |  *.divx  |)
        if [[ $ARG == "" ]]; then
          ARG="--vo=kitty --loop-file=inf -vo-kitty-top=10 -vo-kitty-left=$(( COLUMNS/2 -25 ))\
            --term-status-msg= --vo-kitty-width=800 --vo-kitty-height=800 --vo-kitty-alt-screen=no"
        fi
        mpv $(echo $ARG) $1
      ;;

      image* |\
      *.jpeg |*.bmp | *.jpg | *.png |  *ogv | *.gif | *.xpm |  *.r[am]  | *.mov |\
      *.mpeg |*.mkv | *.mpg | *.vob |  *.ts | *.m2v | *.dat |  *.as[fx] | *.avi |\
      *.divx |*.3gp | *.mp4 | *.m4v |  *.qt | *.mts | *.wmv | *.fl[icv] | *.webm )
        if [[ $ARG == "" ]]; then
          ARG="-C --title=%D:%wx%h"
        fi
        # exiftool -FileName -FileSize -FileType -MediaDuration -AudioFormat -ImageSize $1
        timg $(echo $ARG) $1
        ARG=""
      ;;

      audio*)
        command rm /tmp/ca.Cover.png
        ffmpeg -i $1 /tmp/ca.Cover.png > /dev/null 2> /dev/null
        if [[ ! -e /tmp/ca.musicCover.png ]]; then
          cp $HOME/.config/zsh/wrapers/src/MusicCover.png /tmp/ca.Cover.png
        fi
        export _CAT1=" Title "
        export _CAV1=$( exiftool -s3 -Title $1 )" "
        export _CAT2=" Artist "
        export _CAV2=$( exiftool -s3 -Artist $1 )" "
        export _CAT3=" Album "
        export _CAV3=$( exiftool -s3 -Album $1 )" "
        export _CAT4=" Track "
        export _CAV4=$( exiftool -s3 -Track $1 )" "
        export _CAT5=" Band "
        export _CAV5=$( exiftool -s3 -Band $1 )" "
        export _CAT6=" Genre "
        export _CAV6=$( exiftool -s3 -Genre $1 )" "
        export _CAT7=" Duration "
        export _CAV7=$( exiftool -s3 -Duration $1 )" "
        export _CAT8=" Audio Bitrate "
        export _CAV8=$( exiftool -s3 -AudioBitrate $1 )" "
        export _CAT9=" Sample Rate "
        export _CAV9=$( exiftool -s3 -SampleRate $1 )" "
        export _CAT10=" Publisher "
        export _CAV10=$( exiftool -s3 -Publisher $1 )" "
        export _CAT11=" Encoder Settings "
        export _CAV11=$( exiftool -s3 -EncoderSettings $1 )" "
        export _CAT12=" Media "
        export _CAV12=$( exiftool -s3 -Media $1 )" "
        export _CAT13=" Original Release Time "
        export _CAV13=$( exiftool -s3 -OriginalReleaseTime $1 )" "
        export _CAT14=" Channel Mode "
        export _CAV14=$( exiftool -s3 -ChannelMode $1 )" "
        export _CAT15=" Copyright "
        export _CAV15=$( exiftool -s3 -Copyright $1 )" "
        neofetch --clean
        neofetch --config $HOME/.config/zsh/wrapers/src/config.conf --size 550px\
          --xoffset $((COLUMNS/2 -40)) --yoffset 7 --gap $((COLUMNS/2 - 40)) --source /tmp/ca.Cover.png
        unset  _CAT1 _CAV1 _CAT2 _CAV2 _CAT3 _CAV3 _CAT4 _CAV4 _CAT5 _CAV5\
          _CAT6 _CAV6 _CAT7 _CAV7 _CAT8 _CAV8 _CAT9 _CAV9 _CAT10 _CAV10\
          _CAT11 _CAV11 _CAT12 _CAV12 _CAT13 _CAV13 _CAT14 _CAV14 _CAT15 _CAV15
        trap '' INT
        cuMusicplayer () (
          afplay $@
        )
        cuMusicplayer $(echo $ARG) $1
      ;;

      *.pdf)
        if [[ $ARG == "" ]]; then
          ARG="-WU --grid=3 --frames=6"
        fi
        timg $(echo $ARG) $1
      ;;

      *.epub)
        if [[ $ARG == "" ]]; then
          ARG="-C --title=$(basename $1)"
        fi

        command rm /tmp/ca.Cover.png
        $HOME/Developer/Softwares/Github/epub-thumbnailer/src/epub-thumbnailer.py $1 /tmp/ca.Cover.png 800

        # Settingup neofetch
        export _CAT1=" Title "
        export _CAV1=$( exiftool -s3 -Title $1 )" "
        export _CAT2=" Creator "
        export _CAV2=$( exiftool -s3 -Creator $1 )" "
        export _CAT3=" Publisher "
        export _CAV3=$( exiftool -s3 -Publisher $1 )" "
        export _CAT4=" Source "
        export _CAV4=$( exiftool -s3 -Source $1 )" "
        export _CAT5=" Format "
        export _CAV5=$( exiftool -s3 -Format $1 )" "
        export _CAT6=" Language "
        export _CAV6=$( exiftool -s3 -Language $1 )" "
        export _CAT7=" Type "
        export _CAV7=$( exiftool -s3 -Type $1 )" "
        export _CAT8=" File Size "
        export _CAV8=$( exiftool -s3 -FileSize $1 )" "
        export _CAT9=" Meta Content "
        export _CAV9=$( exiftool -s3 -MetaContent $1 )" "
        export _CAT10=" Manifest Item Href "
        export _CAV10=$( exiftool -s3 -ManifestItemHref $1 )" "
        export _CAT11=" File Type "
        export _CAV11=$( exiftool -s3 -FileType $1 )" "
        export _CAT12=" Rights "
        export _CAV12=$( exiftool -s3 -Rights $1 )" "
        export _CAT13=" File Access Date/Time "
        export _CAV13=$( exiftool -s3 -FileAccessDate $1 )" "
        export _CAT14=" File Inode Change Date "
        export _CAV14=$( exiftool -s3 -FileInodeChangeDate $1 )" "
        export _CAT15=" Identifier "
        export _CAV15=$( exiftool -s3 -Identifier $1 )" "
        neofetch --clean
        neofetch --config $HOME/.config/zsh/wrapers/src/config.conf --size 550px \
          --xoffset $((COLUMNS/2 -40)) --yoffset 7 --gap $((COLUMNS/2 - 40)) --source /tmp/ca.Cover.png
        unset  _CAT1 _CAV1 _CAT2 _CAV2 _CAT3 _CAV3 _CAT4 _CAV4 _CAT5 _CAV5\
          _CAT6 _CAV6 _CAT7 _CAV7 _CAT8 _CAV8 _CAT9 _CAV9 _CAT10 _CAV10\
          _CAT11 _CAV11 _CAT12 _CAV12 _CAT13 _CAV13 _CAT14 _CAV14 _CAT15 _CAV15

        echo "\n\n\n"
      ;;

      *spreadsheet* | *excel* |\
      *.xls | *.csv |  *.ods  | *.tsv )
        if [[ $ARG == "" ]]; then
          ARG="--style=numbers,header,header-filename,grid,snip"
        fi
        if [[ $1 == *.ods ||\
              $1 == *.xls ]]; then
          pyexcel view $1 | bat -l table --file-name "$1 " $(echo $ARG)
        elif [[ "${$(basename "$1")%.*}" != "${$(basename /tmp/op.converted.Document/*.ods)%.*}" ]]; then
          command rm /tmp/op.converted.Document/*.ods
          soffice --headless --convert-to ods --outdir /tmp/op.converted.Document $1 >/dev/null
          pyexcel view /tmp/op.converted.Document/*ods | bat -l table --file-name "$1 " $(echo $ARG)
        fi
      ;;

      *office* |\
      *.doc | *.odt | *.ppt | *.docx | *.xlsx | *.fodp | *.odp|\
      *.ods | *.xls | *.csv | *.pptx | *.fods | *.fodt )
        if [[ "${$(basename "$1")%.*}" != "${$(basename /tmp/op.converted.Document/*.pdf)%.*}" ]]; then
          command rm /tmp/op.converted.Document/*.pdf
          soffice --headless --convert-to pdf --outdir /tmp/op.converted.Document $1 >/dev/null
        fi
        if [[ $ARG == "" ]]; then
          ARG="-WU --grid=3 --frames=6"
        fi
        timg $(echo $ARG) /tmp/op.converted.Document/*pdf
      ;;

      *font*|\
      *.ttf | *.ttc | *.otf | *.pfa | *.pfb | *.pt3 | *.gf | *.otb | *.bmap |\
      *.bdf | *.fon | *.fnt | *woff | *.pfr | *.sfd | *.pk | *.ufo | *.dfont )
        if [[ "${$(basename "$1")%.*}" != "${$(basename /tmp/ca.converted.fontPreview/*.png)%.*}" ]]; then
          command rm /tmp/ca.converted.fontPreview/*.png  > /dev/null
          fontimage -o /tmp/ca.converted.fontPreview/"${$(basename "$1")%.*}".png "$1" 2> /dev/null
        fi
        if [[ $ARG == "" ]]; then
          ARG="-CI"
        fi
        timg $(echo $ARG) /tmp/ca.converted.fontPreview/*.png
      ;;

      *key*)
        if [[ $ARG == "" ]]; then
          ARG="-a --"
        fi
        gpg $(echo $ARG) $1
      ;;

      *archive* |\
      *.zip | *.tgz | *.rpm | *.tgz | *.7z | *.tar.7z*.jar | *.tar.gz |\
      *.tzo | *.tlz | *.deb | *.tbz | *.tZ | *.tbz2 | *.rz | *.tar.bz |\
      *.war | *.rar | *.cab | *.txz | *.gz | *.cpio | *.xz | *.tar.lz |\
      *.arj | *.arc | *.ace | *.lha | *.bz |   *.a  |  *.Z | *.tar.xz |\
      *.lrz | *.bz2 | *.alz | *.lzo | *.lz |   *.tar.lzo   | *.tar.bz2 )
        if [[ $ARG == "" ]]; then
          ARG="-l --"
        fi
        atool $(echo $ARG) $1
      ;;

      *torrent*)
        if [[ $ARG == "" ]]; then
            ARG="--"
        fi
        transmission-show $(echo $ARG) $1
        ARG=""
      ;;

      *)
        if [[ $ARG == "" ]]; then
          ARG=""
        fi
        exiftool $(echo $ARG) $1
      ;;

    esac
    ARG=""
  fi
  echo ""
  shift
done
if [[ $ERR != "" ]]; then
    echo -n "\033[31;1m[ca error]\033[0m No such file(s) or directory(s) (os error 2): "
    #         [Remove last ","][              Reverse the input String               ][ Replace 1st "," with "dna" ][              Reverse the input String              ]
    echo $ERR | sed 's/, *$//' | sed $'s/./&\\\n/g' | sed -ne $'x;H;${x;s/\\n//g;p;}' | sed -E 's/,([^,]?)/dna \1/' | sed $'s/./&\\\n/g' | sed -ne $'x;H;${x;s/\\n//g;p;}'
    unset ARG
    unset ERR
    return 2
elif [[ $ARG != "" ]]; then
    echo "Help $ARG"
    unset ARG
    unset ERR
    return 1
else
    unset ARG
    unset ERR
    return
fi
