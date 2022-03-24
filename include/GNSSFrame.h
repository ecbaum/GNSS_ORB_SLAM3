


#ifndef GNSSFRAME_H
#define GNSSFRAME_H

#include "Frame.h"
#include "ImuTypes.h"
#include "KeyFrame.h"
#include "SerializationUtils.h"

#include <mutex>

#include <boost/serialization/base_object.hpp>
#include <boost/serialization/vector.hpp>
#include <boost/serialization/map.hpp>

#include <vector>
namespace ORB_SLAM3
{

class KeyFrame;



class GNSSFrame
{

   

public:
    GNSSFrame();
    KeyFrame* parentKeyFrame;
    double acc;
    double angVel;
    double tstep; 
    
   /*
    IMU::Preintegrated* mpImuPreintegrated;
    IMU::Calib mImuCalib;
    IMU::Bias mImuBias;



    std::mutex mMutexPose; // for pose, velocity and biases


      // Pose functions
    void SetPose(const Sophus::SE3f &Tcw);
    void SetVelocity(const Eigen::Vector3f &Vw_);

    Sophus::SE3f GetPose();
    Sophus::SE3f GetPoseInverse();
    Eigen::Vector3f GetImuPosition();
    Eigen::Matrix3f GetImuRotation();
    Sophus::SE3f GetImuPose();
    Eigen::Matrix3f GetRotation();
    Eigen::Vector3f GetTranslation();
    Eigen::Vector3f GetVelocity();
    bool isVelocitySet();



        // sophus poses
    Sophus::SE3<float> mTcw;
    Eigen::Matrix3f mRcw;
    Sophus::SE3<float> mTwc;
    Eigen::Matrix3f mRwc;

    // IMU position
    Eigen::Vector3f mOwb;
    // Velocity (Only used for inertial SLAM)
    Eigen::Vector3f mVw;
    bool mbHasVelocity;
;

    // Imu bias
    IMU::Bias mImuBias;
*/
    int a;
protected:
  
};

} //namespace ORB_SLAM

#endif // GNSSFRAME_H
