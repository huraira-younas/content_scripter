import React, { useEffect, useState } from "react";
// import { useDispatch, useSelector } from "react-redux";
// import {
//   deleteOnBoarding,
//   getOnBoarding,
// } from "../../../store/features/onBoarding/onBoardingService";
// import { deleteImage } from "../../../utils/api_methods";
// import { FILES_DELETE } from "../../../routes/route";
import OnBoardingScreen from "../../../../components/Screens/Home/OnBoarding/List/ListOnBoardingScreen";
import ConfirmModel from "../../../../components/common/ConfirmModel/ConfirmModel";
import Loader from "../../../../components/common/loader/loader";
import { FILES_DELETE } from "../../../../routes/routes";
import { deleteImage } from "../../../../utils/api_methods";
import {
  deleteOnBoarding,
  getOnBoarding,
} from "../../../../redux/onBoarding/action";
import { selectOnBoarding, selectOnboardingLoader } from "../../../selectors";
import { useDispatch, useSelector } from "react-redux";
import { ToastContainer } from "react-toastify";

const OnBoarding = () => {
  const [obj, setObj] = useState(null);
  const [confirmModal, setConfirmModal] = useState(null);
  const [selectedImage, setSelectedImage] = useState("");
  const [searchInput, setSearchInput] = useState("");
  const [showModal, setShowModal] = useState(false);

  const dispatch = useDispatch();
  const onBoarding = useSelector(selectOnBoarding);
  const loader = useSelector(selectOnboardingLoader);

  useEffect(() => {
    if (onBoarding?.length) return;
    dispatch(getOnBoarding());
  }, []);
  const handleOpenModal = (id, imgUrl) => {
    setConfirmModal(true);
    setObj({ id, imgUrl });
  };

  const handleDelete = async () => {
    if (!onBoarding.length) return;
    await deleteImage({
      url: FILES_DELETE,
      imgUrl: obj.imgUrl,
    });

    // debugger;
    dispatch(deleteOnBoarding(obj.id, onBoarding));
    setConfirmModal(false);
    setObj(null);
  };

  const handleCloseModal = () => {
    setConfirmModal(false);
    setObj(null);
  };

  const handleImageClick = (imageUrl) => {
    setSelectedImage(imageUrl);
    setShowModal(true);
  };

  const handleClose = () => setShowModal(false);
  return (
    <>
      <OnBoardingScreen
        onBoarding={onBoarding}
        handleOpenModal={handleOpenModal}
        handleImageClick={handleImageClick}
        handleClose={handleClose}
        selectedImage={selectedImage}
        setSearchInput={setSearchInput}
        showModal={showModal}
        searchInput={searchInput}
        loader={loader}
      />
      <ConfirmModel
        showModal={confirmModal}
        handleCloseModal={handleCloseModal}
        handleConfirm={handleDelete}
      />
      <ToastContainer />
    </>
  );
};

export default OnBoarding;
