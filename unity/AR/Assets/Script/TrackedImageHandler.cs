using UnityEngine;
using UnityEngine.Video;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;

public class TrackedImageHandler : MonoBehaviour
{
    private ARTrackedImageManager trackedImageManager;
    private bool triggerDetected = false; // ตัวแปรสถานะว่าตรวจพบ TriggerAR แล้ว
    private VideoPlayer videoPlayer;

    private void Awake()
    {
        trackedImageManager = FindObjectOfType<ARTrackedImageManager>();
        videoPlayer = FindObjectOfType<VideoPlayer>(); // สมมติว่ามี VideoPlayer ตัวเดียวในฉาก
    }

    private void OnEnable()
    {
        trackedImageManager.trackedImagesChanged += OnTrackedImagesChanged;
    }

    private void OnDisable()
    {
        trackedImageManager.trackedImagesChanged -= OnTrackedImagesChanged;
    }

    private void OnTrackedImagesChanged(ARTrackedImagesChangedEventArgs eventArgs)
    {
        foreach (var trackedImage in eventArgs.added)
        {
            UpdateImage(trackedImage);
        }

        foreach (var trackedImage in eventArgs.updated)
        {
            UpdateImage(trackedImage);
        }

        foreach (var trackedImage in eventArgs.removed)
        {
            HandleRemovedImage(trackedImage);
        }
    }

    private void UpdateImage(ARTrackedImage trackedImage)
    {
        if (trackedImage.referenceImage.name == "TriggerAR" && trackedImage.trackingState == TrackingState.Tracking && !triggerDetected)
        {
            // ตรวจพบ TriggerAR ครั้งแรก
            triggerDetected = true;
            Debug.Log("TriggerAR detected, waiting for CoverARR.");

            var coverImage = FindTrackedImage("CoverARR");
            if (coverImage != null)
            {
                coverImage.gameObject.SetActive(true);
                coverImage.gameObject.transform.position = coverImage.transform.position;
                coverImage.gameObject.transform.rotation = coverImage.transform.rotation;
                if (!videoPlayer.isPlaying)
                {
                    videoPlayer.Play();
                }
            }
        }
        else if (trackedImage.referenceImage.name == "CoverARR" && trackedImage.trackingState == TrackingState.Tracking && triggerDetected)
        {
            // แสดงวิดีโอเมื่อพบ CoverARR หลังจากตรวจจับ TriggerAR
            trackedImage.gameObject.SetActive(true);
            trackedImage.gameObject.transform.position = trackedImage.transform.position;
            trackedImage.gameObject.transform.rotation = trackedImage.transform.rotation;
            if (!videoPlayer.isPlaying)
            {
                videoPlayer.Play();
            }
        }
        else
        {
            trackedImage.gameObject.SetActive(false);
        }
    }

    private void HandleRemovedImage(ARTrackedImage trackedImage)
    {
        if (trackedImage.referenceImage.name == "CoverARR" && triggerDetected)
        {
            // หยุดวิดีโอเมื่อ CoverARR หายไป
            if (videoPlayer.isPlaying)
            {
                videoPlayer.Stop();
            }
            Debug.Log("CoverARR removed, stopping video.");
        }

        trackedImage.gameObject.SetActive(false);
    }

    private ARTrackedImage FindTrackedImage(string imageName)
    {
        foreach (var trackedImage in trackedImageManager.trackables)
        {
            if (trackedImage.referenceImage.name == imageName)
            {
                return trackedImage;
            }
        }
        return null;
    }
}
