# SFX TTS

Script that allows you to use TTS voices and play audio files via chat messages

`sf_filedata`
```
sf_filedata
└───sfx_tts
    ├───aliases.json
    └───samples
        └───. . .
```

`aliases.json`
```json
{
  "file_name": [
    "alias text/trigger word",
    . . .
  ],
  . . .
}
```

`Script Globals`
```
// Bass manipulating
_VOLUME - volume of the sounds (1 to 10)
_PITCH - pitch of the sounds (1 to 200; Recommended to stay between 0.1 to 2)

// TTS voice settings
_TTS_ENGINE - id of engine used by the tts voice
_TTS_VOICE - id of the tts voice
_TTS_LANG - id of the language used by the tts voice

// other values you probably shouldn't modify
_DIR - directory used by the script
_PREFIX - string added to the front of the the temp file names (temp files cannot be deleted, so we have to write them again with a different file name if they bug out)
_BASS_MAX - the max amount of bass objects the client can have (cannot be greater than sf_bass_max_cl for any of the clients, otherwise an error is possible)
```
