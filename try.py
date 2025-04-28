from pydub import AudioSegment

# Load the song (replace with your path)
song = AudioSegment.from_mp3("song.mp3")

# Define jingle segments (e.g., intro + chorus + bridge)
intro = song[0:7000]          # First 7 seconds
chorus = song[60000:75000]    # Chorus segment (example: from 1:00 to 1:15)
bridge = song[120000:128000]  # Another catchy part (example: 2:00 to 2:08)

# Combine parts into a jingle
jingle = intro + chorus + bridge

# Optional: fade in/out for better effect
jingle = jingle.fade_in(2000).fade_out(2000)

# Export the jingle
jingle.export("taylor_swift_jingle.mp3", format="mp3")

print("✨ Jingle created successfully!")
