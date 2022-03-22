
#include "KeyFrame.h"
#include "Converter.h"
#include "ImuTypes.h"
#include "GNSSFrame.h"
#include<mutex>


namespace ORB_SLAM3
{
GNSSFrame::GNSSFrame(KeyFrame &F):
    bImu(pMap->isImuInitialized()),  mTimeStamp(F.mTimeStamp)
    mImuCalib(F.mImuCalib),
{


    if(!F.HasVelocity()) {
        mVw.setZero();
        mbHasVelocity = false;
    }
    else
    {
        mVw = F.GetVelocity();
        mbHasVelocity = true;
    }
    
    mImuBias = F.mImuBias;
    SetPose(F.GetPose());
    mnOriginMapId = pMap->GetId();

    accBetweenKFs; //GNSS Martin
    angVelBetweenKFs; //GNSS Martin
    tstepBetweenKFs; //GNSS Martin}


    //Erik
    insertGNSS = false;
    GNSSiter = 0;
    mpImuPreintegratedToGNSS;
    mpImuPreintegratedFromGNSS;
    timeStampGNSS;
    //E

}

void GNSSFrame::SetPose(const Sophus::SE3f &Tcw)
{
    unique_lock<mutex> lock(mMutexPose);

    mTcw = Tcw;
    mRcw = mTcw.rotationMatrix();
    mTwc = mTcw.inverse();
    mRwc = mTwc.rotationMatrix();

    if (mImuCalib.mbIsSet) // TODO Use a flag instead of the OpenCV matrix
    {
        mOwb = mRwc * mImuCalib.mTcb.translation() + mTwc.translation();
    }
}

void GNSSFrame::SetVelocity(const Eigen::Vector3f &Vw)
{
    unique_lock<mutex> lock(mMutexPose);
    mVw = Vw;
    mbHasVelocity = true;
}

Sophus::SE3f GNSSFrame::GetPose()
{
    unique_lock<mutex> lock(mMutexPose);
    return mTcw;
}

Sophus::SE3f GNSSFrame::GetPoseInverse()
{
    unique_lock<mutex> lock(mMutexPose);
    return mTwc;
}


Eigen::Vector3f GNSSFrame::GetImuPosition()
{
    unique_lock<mutex> lock(mMutexPose);
    return mOwb;
}

Eigen::Matrix3f GNSSFrame::GetImuRotation()
{
    unique_lock<mutex> lock(mMutexPose);
    return (mTwc * mImuCalib.mTcb).rotationMatrix();
}

Sophus::SE3f GNSSFrame::GetImuPose()
{
    unique_lock<mutex> lock(mMutexPose);
    return mTwc * mImuCalib.mTcb;
}

Eigen::Matrix3f GNSSFrame::GetRotation(){
    unique_lock<mutex> lock(mMutexPose);
    return mRcw;
}

Eigen::Vector3f GNSSFrame::GetTranslation()
{
    unique_lock<mutex> lock(mMutexPose);
    return mTcw.translation();
}

Eigen::Vector3f GNSSFrame::GetVelocity()
{
    unique_lock<mutex> lock(mMutexPose);
    return mVw;
}

bool GNSSFrame::isVelocitySet()
{
    unique_lock<mutex> lock(mMutexPose);
    return mbHasVelocity;
}


void GNSSFrame::SetNewBias(const IMU::Bias &b)
{
    unique_lock<mutex> lock(mMutexPose);
    mImuBias = b;
    if(mpImuPreintegrated)
        mpImuPreintegrated->SetNewBias(b);
}

Eigen::Vector3f GNSSFrame::GetGyroBias()
{
    unique_lock<mutex> lock(mMutexPose);
    return Eigen::Vector3f(mImuBias.bwx, mImuBias.bwy, mImuBias.bwz);
}

Eigen::Vector3f GNSSFrame::GetAccBias()
{
    unique_lock<mutex> lock(mMutexPose);
    return Eigen::Vector3f(mImuBias.bax, mImuBias.bay, mImuBias.baz);
}


IMU::Bias GNSSFrame::GetImuBias()
{
    unique_lock<mutex> lock(mMutexPose);
    return mImuBias;
}

void GNSSFrame::IntegrateBetweenGNSS(){
    mpImuPreintegratedToGNSS = new IMU::Preintegrated(mPrevKF->mImuBias,mPrevKF->mImuCalib);
    
    //double tIter = tStart;
    double _tempFraction = 0.6; //Before GNSS time is implmented and loaded, we use _tempFraction as to "simualte" what fraction of delta time from last to current keyframe its located

    bool _nextPreIntInit = false;
    std::cout << "from previous keyframe to GNSS node" << std::endl;
    for(int i = 0; i < accBetweenKFs.size(); i++){
        Eigen::Matrix<float, 3, 1> acc = accBetweenKFs[i];
        Eigen::Matrix<float, 3, 1> angVel = angVelBetweenKFs[i];
        double tstep = tstepBetweenKFs[i];
        
        /*tIter += tstep;
        if tIter < timeStampGNSS{*/
        
        if(i < accBetweenKFs.size()*_tempFraction){
            mpImuPreintegratedToGNSS->IntegrateNewMeasurement(acc,angVel,tstep);
        }else if(!_nextPreIntInit){
            mpImuPreintegratedFromGNSS = new IMU::Preintegrated(mpImuPreintegratedToGNSS);
            _nextPreIntInit = true;
            std::cout << "from GNSS node to current keyframe" << std::endl;
        }else{
            mpImuPreintegratedFromGNSS->IntegrateNewMeasurement(acc,angVel,tstep);
        }
    }
}


//E

} //namespace ORB_SLAM

