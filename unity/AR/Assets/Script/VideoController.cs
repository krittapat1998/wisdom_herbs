using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;
using UnityEngine.XR.ARFoundation;

public class VideoController : MonoBehaviour
{
    public VideoPlayer videoPlayer;
    private ARTrackedImageManager _arTrackedImageManager;

    void Start()
    {
        if (videoPlayer == null)
        {
            videoPlayer = GetComponent<VideoPlayer>();
        }

        // ค้นหา ARTrackedImageManager ใน scene
        _arTrackedImageManager = FindObjectOfType<ARTrackedImageManager>();

        if (_arTrackedImageManager != null)
        {
            _arTrackedImageManager.trackedImagesChanged += OnTrackedImagesChanged;
        }
    }

    void OnDestroy()
    {
        if (_arTrackedImageManager != null)
        {
            _arTrackedImageManager.trackedImagesChanged -= OnTrackedImagesChanged;
        }
    }

    private void OnTrackedImagesChanged(ARTrackedImagesChangedEventArgs eventArgs)
    {
        // ตรวจสอบภาพที่ถูกติดตามแล้ว
        foreach (var trackedImage in eventArgs.updated)
        {
            if (trackedImage.trackingState == UnityEngine.XR.ARSubsystems.TrackingState.Tracking)
            {
                // ถ้า image กำลังถูกติดตามให้เล่นวิดีโอ
                PlayVideo();
            }
            else if (trackedImage.trackingState == UnityEngine.XR.ARSubsystems.TrackingState.Limited ||
                     trackedImage.trackingState == UnityEngine.XR.ARSubsystems.TrackingState.None)
            {
                // ถ้า image ไม่ถูกติดตามให้หยุดวิดีโอ
                PauseVideo();
            }
        }
    }

    public void PlayVideo()
    {
        if (videoPlayer != null)
        {
            videoPlayer.Play();
        }
    }

    public void PauseVideo()
    {
        if (videoPlayer != null)
        {
            videoPlayer.Pause();
        }
    }
}
