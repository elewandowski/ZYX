import android.media.*;

public class AndroidAudioDevice
{
  AudioTrack track;
  short[] buffer;

  public AndroidAudioDevice() {
    int minSize = AudioTrack.getMinBufferSize( 44100, AudioFormat.CHANNEL_CONFIGURATION_STEREO, AudioFormat.ENCODING_PCM_16BIT );
    println("buffer size = "+minSize);
    buffer = new short[minSize];    
    track = new AudioTrack( AudioManager.STREAM_MUSIC, 44100, 
    AudioFormat.CHANNEL_CONFIGURATION_STEREO, AudioFormat.ENCODING_PCM_16BIT, 
    minSize, AudioTrack.MODE_STREAM);
    track.play();
  }

  public void writeSamples(float[] samples) {	
    fillBuffer( samples );
    track.write( buffer, 0, samples.length );
  }

  private void fillBuffer(float[] samples) {
    if ( buffer.length < samples.length )
      buffer = new short[samples.length];

    for ( int i = 0; i < samples.length; i++ )
      buffer[i] = (short)(samples[i] * Short.MAX_VALUE);
    ;
  }
}

