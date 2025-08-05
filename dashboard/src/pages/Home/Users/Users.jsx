import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { getUsers } from "../../../redux/users/action";
import { useLocation, useNavigate } from "react-router-dom";
import { selectUsers, selectUsersLoader } from "../../selectors";
import UsersScreen from "../../../components/Screens/Home/Users/UsersScreen";

const Users = () => {
  const limit = 10;
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const location = useLocation();

  const users = useSelector(selectUsers);
  const { totalPages, totalUsers } = users;
  const [online, setOnline] = useState("");
  const [gender, setGender] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const usersLoader = useSelector(selectUsersLoader);
  const [searchUsers, setSearchUsers] = useState("");
  const [selectedCountry, setSelectedCountry] = useState("");

  const handleGenderChange = (e) => {
    setGender(e.target.value);
  };

  useEffect(() => {
    const searchParams = new URLSearchParams(location.search);
    setCurrentPage(parseInt(searchParams.get("page") || 1));
    setSearchUsers(searchParams.get("search") || "");
    setOnline(searchParams.get("online") || "");
    setGender(searchParams.get("gender") || "");
    setSelectedCountry(searchParams.get("country") || "");
  }, []);

  useEffect(() => {
    const abortController = new AbortController();

    const handleSelectChange = () => {
      const urlSearchParams = new URLSearchParams();
      // if (currentPage > 1 && searchUsers) {
      //   setCurrentPage(1);
      // }
      if (currentPage) {
        urlSearchParams.set("page", currentPage);
      }
      urlSearchParams.set("limit", limit);

      if (searchUsers) {
        urlSearchParams.set("search", searchUsers);
      }

      if (gender) {
        urlSearchParams.set("gender", gender);
      }

      if (online) {
        urlSearchParams.set("online", online);
      }

      if (selectedCountry) {
        urlSearchParams.set("country", selectedCountry);
      }

      const newUrl = `?${urlSearchParams}`;
      navigate(newUrl);
      dispatch(getUsers({ signal: abortController.signal, search: newUrl }));
    };

    handleSelectChange();

    return () => {
      abortController.abort();
    };
  }, [
    searchUsers,
    gender,
    online,
    selectedCountry,
    currentPage,
    limit,
    navigate,
    dispatch,
  ]);

  return (
    <UsersScreen
      limit={limit}
      loader={usersLoader}
      users={users?.users}
      totalPages={totalPages}
      totalUsers={totalUsers}
      currentPage={currentPage}
      searchUsers={searchUsers}
      setCurrentPage={setCurrentPage}
      setSearchUsers={setSearchUsers}
      selectedCountry={selectedCountry}
      handleGenderChange={handleGenderChange}
      setSelectedCountry={setSelectedCountry}
    />
  );
};

export default Users;
