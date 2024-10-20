using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using UnityEngine.Video;
using UnityEngine.UI;
using FlutterUnityIntegration;

public class FlutterMessageHandler : MonoBehaviour
{
    public VideoPlayer videoPlayer;

    void Start()
    {
        Debug.Log("Unity Message Manager Started");
        UnityMessageManager.Instance.OnMessage += OnMessage;

    }

    void OnDestroy()
    {
        UnityMessageManager.Instance.OnMessage -= OnMessage;
    }

    // Method ที่จะถูกเรียกเมื่อมีข้อความมาจาก Flutter
    void OnMessage(string message)
    {
        Debug.Log("Received message from Flutter: " + message);

        if (message == "play")
        {
            PlayVideo();
        }
        else if (message == "pause")
        {
            PauseVideo();
        }
    }

    void PlayVideo()
    {
        if (videoPlayer != null)
        {
            videoPlayer.Play();
        }
    }

    void PauseVideo()
    {
        if (videoPlayer != null)
        {
            videoPlayer.Pause();
        }
    }
}

