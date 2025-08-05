import {
  selectAssistant,
  selectAssistantLoader,
  selectDeleteAssistantLoader,
} from "../../../selectors";
import {
  getAssistant,
  deleteAssistant,
} from "../../../../redux/assistant/action";
import ConfirmModel from "../../../../components/common/ConfirmModel/ConfirmModel";
import ListScreen from "../../../../components/Screens/Home/Assistant/List/ListScreen";
import { deleteImage } from "../../../../utils/api_methods";
import { FILES_DELETE } from "../../../../routes/routes";
import { useDispatch, useSelector } from "react-redux";
import { ToastContainer } from "react-toastify";
import { useEffect, useState } from "react";

const List = () => {
  const [confirmModal, setConfirmModal] = useState(null);
  const [selectedImage, setSelectedImage] = useState("");
  const [searchInput, setSearchInput] = useState("");
  const [showModal, setShowModal] = useState(false);
  const [obj, setObj] = useState(null);

  const delLoader = useSelector(selectDeleteAssistantLoader);
  const loader = useSelector(selectAssistantLoader);
  const assistant = useSelector(selectAssistant);
  const dispatch = useDispatch();

  useEffect(() => {
    if (assistant?.length) return;
    dispatch(getAssistant());
  }, []);

  const handleOpenModal = (id, imgUrl) => {
    setConfirmModal(true);
    setObj({ id, imgUrl });
  };

  const handleDelete = async () => {
    if (!assistant.length) return;
    await deleteImage({
      url: FILES_DELETE,
      imgUrl: obj.imgUrl,
    });

    dispatch(deleteAssistant(obj.id, assistant));
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
      <ListScreen
        handleImageClick={handleImageClick}
        handleOpenModal={handleOpenModal}
        setSearchInput={setSearchInput}
        selectedImage={selectedImage}
        handleClose={handleClose}
        searchInput={searchInput}
        showModal={showModal}
        assistant={assistant}
        loader={loader}
      />
      <ConfirmModel
        handleCloseModal={handleCloseModal}
        handleConfirm={handleDelete}
        showModal={confirmModal}
        loader={delLoader}
      />
      <ToastContainer />
    </>
  );
};

export default List;
