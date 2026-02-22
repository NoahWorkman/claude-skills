# YouTube Channel/Playlist Downloader

Download the most recent videos from a YouTube channel or playlist at the highest available quality.

## Parameters
Parse from user input:
- **URL**: YouTube channel or playlist URL (required)
- **Count**: Number of videos to download (default: 10)
- **Output folder**: Where to save (default: ~/Downloads/[channel_name])

## Instructions

1. **First, update yt-dlp** to avoid streaming issues:
   ```bash
   brew upgrade yt-dlp 2>/dev/null || true
   ```

2. **List videos** to confirm with user:
   ```bash
   yt-dlp --flat-playlist --playlist-items 1:$COUNT -j "$URL" 2>/dev/null | jq -r '.title'
   ```

3. **Ask user to confirm** the video list before downloading.

4. **Create output folder** and download at max quality:
   ```bash
   mkdir -p "$OUTPUT_FOLDER"
   cd "$OUTPUT_FOLDER"
   yt-dlp --playlist-items 1:$COUNT \
     -f "bestvideo+bestaudio/best" \
     --merge-output-format mp4 \
     --embed-thumbnail \
     --embed-metadata \
     -o "%(upload_date)s - %(title)s.%(ext)s" \
     --restrict-filenames \
     --progress \
     "$URL"
   ```

   **Why this format string works:**
   - `bestvideo+bestaudio` grabs the highest quality streams regardless of container (VP9/AV1 in webm, H.264 in mp4, Opus audio, etc.)
   - `--merge-output-format mp4` uses ffmpeg to merge into a universal .mp4
   - Do NOT restrict to `[ext=mp4]` — that caps quality by excluding higher-bitrate webm streams
   - `--embed-thumbnail` and `--embed-metadata` preserve channel art and video info

5. **Verify and report** (always run this automatically after download):
   ```bash
   echo "=== Download Summary ==="
   du -sh "$OUTPUT_FOLDER"
   echo ""
   for f in "$OUTPUT_FOLDER"/*.mp4; do
     echo "$(basename "$f")"
     echo "  Video: $(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name,width,height -of csv=p=0 "$f")"
     echo "  Audio: $(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name,sample_rate,bit_rate -of csv=p=0 "$f")"
     echo "  FPS:   $(ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of csv=p=0 "$f")"
     echo "  Size:  $(ls -lh "$f" | awk '{print $5}')"
     echo ""
   done
   ```

   Present results as a table:
   | Video | Resolution | Video Codec | Audio Codec | FPS | Size |

6. **Quality check** — flag any issues:
   - Resolution below 1080p (source may only offer lower)
   - Mixed framerates across videos
   - Missing audio stream
   - Any .part files (incomplete downloads)

## Notes
- `--restrict-filenames` avoids special characters in filenames
- Date prefix keeps videos sorted chronologically
- If downloads fail with 403 errors, ensure yt-dlp is updated
- ffmpeg is required for merging — install with `brew install ffmpeg` if missing
