import * as Yup from "yup";
import { useFormik } from "formik";
import { useEffect, useState } from "react";
import { ToastContainer } from "react-toastify";
import { useDispatch, useSelector } from "react-redux";
import {
  selectAdmin,
  selectHelpCenter,
  selectUpdateLoader,
} from "../../../selectors";
import { removeAtIndex, updateIndexValue } from "../../../../utils/utils";
import Model from "../../../../components/Screens/Home/Setting/Faq/Model/Model";
import {
  addHelpCenter,
  deleteHelpCenter,
  getHelpCenter,
  updateHelpCenter,
} from "../../../../redux/setting/action";
import FaqScreen from "../../../../components/Screens/Home/Setting/Faq/FaqScreen";
import ConfirmModel from "../../../../components/common/ConfirmModel/ConfirmModel";

const Faq = () => {
  const dispatch = useDispatch();
  const admin = useSelector(selectAdmin);
  const [showModal, setShowModal] = useState("");
  const [values, setValues] = useState(undefined);
  const helpcenter = useSelector(selectHelpCenter);
  const updateLoader = useSelector(selectUpdateLoader);
  const [itemIndex, setItemIndex] = useState(undefined);
  const [activeButton, setActiveButton] = useState("All");
  const [showDeleteModal, setShowDeleteModal] = useState(false);

  useEffect(() => {
    if (!Object.keys(helpcenter).length) dispatch(getHelpCenter());
  }, []);

  const handleDelete = () => {
    if (!itemIndex) return;
    const { catName, index } = itemIndex;

    const updatedFaq = helpcenter.faq
      .map((category) => {
        if (category.catName === catName) {
          const updatedItems = removeAtIndex(category.items, index);
          if (updatedItems.length === 0) {
            setActiveButton("All");
            return null;
          }
          return { ...category, items: updatedItems };
        }
        return category;
      })
      .filter(Boolean);

    const payload = {
      email: admin?.email,
      ...helpcenter,
      faq: updatedFaq,
    };
    dispatch(deleteHelpCenter(payload));
    handleCloseDeleteModal();
  };

  const createOrUpdateFAQ = (faq, action, catName, updatedFaq, index) => {
    const indexToUpdate = faq?.findIndex((cat) => cat.catName === catName);

    if (indexToUpdate !== -1) {
      const updatedItems = [...faq];
      const update = updatedItems[indexToUpdate];

      switch (action) {
        case "create":
          updatedItems[indexToUpdate] = {
            ...update,
            items: [...update.items, updatedFaq],
          };
          break;

        case "update":
          updatedItems[indexToUpdate] = {
            ...update,
            items: updateIndexValue(update.items, updatedFaq, index),
          };
          break;

        default:
          break;
      }

      return updatedItems;
    }

    return faq;
  };

  const formik = useFormik({
    initialValues: {
      category: "",
      title: "",
      text: "",
    },
    onSubmit: (values) => {
      const { faq } = helpcenter;
      const { category, title, text } = values;
      const uniqueCat = [
        ...new Set(faq.map((cat) => cat.catName.toLowerCase())),
      ];

      if (
        showModal === "createAll" &&
        uniqueCat.includes(category.toLowerCase())
      ) {
        formik.setErrors({ category: "duplicate category" });
        return;
      }

      let updatedItems;

      switch (showModal) {
        case "createAll":
          updatedItems = [
            ...faq,
            { catName: category, items: [{ title, text }] },
          ];
          break;

        case "create":
          updatedItems = createOrUpdateFAQ(faq, "create", activeButton, {
            title,
            text,
          });
          break;

        case "update":
          updatedItems = createOrUpdateFAQ(
            faq,
            "update",
            itemIndex.catName,
            { title, text },
            itemIndex.index
          );
          break;

        default:
          break;
      }

      const payload = {
        email: admin?.email,
        ...helpcenter,
        faq: updatedItems,
      };

      if (showModal === "createAll" || showModal === "create") {
        dispatch(addHelpCenter(payload));
      } else if (showModal === "update") {
        dispatch(updateHelpCenter(payload));
      }
      setShowModal("");
      formik.resetForm();
    },
    validationSchema: Yup.object().shape({
      title: Yup.string().required("Title is required"),
      text: Yup.string().required("Description is required"),
    }),
  });

  const handleCloseDeleteModal = () => {
    setShowDeleteModal(false);
  };

  const handleDeleteButtonClick = (catName, index) => {
    setShowDeleteModal(true);
    setItemIndex({ catName, index });
  };

  const handleOpenModel = ({ trigger, catName, index, title, text }) => {
    if (trigger === "update") {
      setValues({ title, text });
      setItemIndex({ catName, index });
      formik.setValues({ title: title, text: text });
    }
    setShowModal(trigger);
  };

  const handleCloseModel = () => {
    setShowModal("");
    formik.resetForm();
  };

  return (
    <>
      <FaqScreen
        showModal={handleOpenModel}
        activeButton={activeButton}
        setActiveButton={setActiveButton}
        handleDeleteButtonClick={handleDeleteButtonClick}
      />
      <Model
        values={values}
        trigger={showModal}
        errors={formik.errors}
        touched={formik.touched}
        handleValue={formik.values}
        activeButton={activeButton}
        handleSubmit={formik.handleSubmit}
        handleChange={formik.handleChange}
        handleCloseModal={handleCloseModel}
      />
      <ConfirmModel
        loader={updateLoader}
        showModal={showDeleteModal}
        handleConfirm={handleDelete}
        handleCloseModal={handleCloseDeleteModal}
      />
      <ToastContainer />
    </>
  );
};

export default Faq;
