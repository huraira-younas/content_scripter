import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import ListMembershipScreen from "../../../../components/Screens/Home/Membership/Plan/List/ListMembershipScreen";
import {
  selectMembership,
  selectMembershipLoader,
  selectMembershipGetLoader,
  selectMembershipTime,
  selectMembershipTimeGetLoader,
  selectMembershipTimeLoader,
} from "../../../selectors";
import {
  deleteMembership,
  getMembership,
} from "../../../../redux/membership/plan/action";
import { getMembershipTime } from "../../../../redux/membership/time/action";

const ListMembership = () => {
  const dispatch = useDispatch();
  const [obj, setObj] = useState(null);
  const membership = useSelector(selectMembership);
  const [searchInput, setSearchInput] = useState("");
  const [confirmModal, setConfirmModal] = useState(null);
  const membershipTime = useSelector(selectMembershipTime);
  const [selectedIndex, setSelectedIndex] = useState(0);
  const [selectedTime, setSelectedTime] = useState(null);
  const membershipLoader = useSelector(selectMembershipLoader);
  const membershipGetLoader = useSelector(selectMembershipGetLoader);
  const membershipTimeLoader = useSelector(selectMembershipTimeLoader);
  const membershipTimeGetLoader = useSelector(selectMembershipTimeGetLoader);

  useEffect(() => {
    if (membership?.length) return;
    dispatch(getMembership());
  }, []);

  useEffect(() => {
    if (membershipTime?.length) return;
    dispatch(getMembershipTime());
  }, []);

  const handleOpenModal = (id) => {
    setConfirmModal(true);
    setObj(id);
  };

  const handleDelete = () => {
    dispatch(deleteMembership(obj, membership));
    setConfirmModal(false);
    setObj(null);
  };

  const handleCloseModal = () => {
    setConfirmModal(false);
    setObj(null);
  };

  const handleSelect = (eventKey, event) => {
    const selectedId = event.target.id;
    setSelectedIndex(eventKey);
    setSelectedTime(membershipTime[eventKey].time);
  };

  return (
    <ListMembershipScreen
      membershipTime={membershipTime}
      membership={membership}
      loader={
        membershipGetLoader ||
        membershipLoader ||
        membershipTimeGetLoader ||
        membershipTimeLoader
      }
      handleOpenModal={handleOpenModal}
      confirmModal={confirmModal}
      handleDelete={handleDelete}
      handleCloseModal={handleCloseModal}
      filteredUser={membership}
      handleSelect={handleSelect}
      selectedTime={selectedTime}
      selectedIndex={selectedIndex}
      searchInput={searchInput}
      setSearchInput={setSearchInput}
    />
  );
};

export default ListMembership;
