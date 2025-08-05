import CreateOnBoarding from "./pages/Home/OnBoarding/CreateOnBoarding/CreateOnBoarding.jsx";
import CreateMembership from "./pages/Home/Membership/Plan/CreateMembership.jsx";
import MembershipTime from "./pages/Home/Membership/Time/MembershipTime.jsx";
import ListMembership from "./pages/Home/Membership/Plan/ListMembership.jsx";
import { BrowserRouter, Navigate, Route, Routes } from "react-router-dom";
import AuthLayout from "./components/common/Authorization/AuthLayout.jsx";
import OnBoarding from "./pages/Home/OnBoarding/List/ListOnBoarding.jsx";
import Privacy from "./pages/Home/Setting/Privacy/Privacy.jsx";
import Contact from "./pages/Home/Setting/Contact/Contact.jsx";
import Create from "./pages/Home/Assistant/Create/Create.jsx";
import Loader from "./components/common/loader/loader.jsx";
import Terms from "./pages/Home/Setting/Terms/Terms.jsx";
import List from "./pages/Home/Assistant/List/List.jsx";
import Prompt from "./pages/Home/Prompt/Prompt.jsx";
import Faq from "./pages/Home/Setting/Faq/Faq.jsx";
import Users from "./pages/Home/Users/Users.jsx";
import Login from "./pages/Login/Login.jsx";
import ReactDOM from "react-dom/client";
import { Provider } from "react-redux";
import App from "./pages/Home/App.jsx";
import store from "./redux/store.jsx";
import React from "react";
import "./index.scss";

ReactDOM.createRoot(document.getElementById("root")).render(
  <Provider store={store}>
    <React.Fragment>
      <BrowserRouter>
        <React.Suspense fallback={<Loader />}>
          <Routes>
            <Route
              element={<Navigate to={"users/list"} />}
              path="/dashboard"
              index={true}
            />
            <Route
              path="/dashboard"
              element={
                <AuthLayout authentication={true}>
                  <App />
                </AuthLayout>
              }
            >
              <Route
                path={`${import.meta.env.BASE_URL}users/list`}
                element={<Users />}
                index={true}
              />
              <Route
                path={`${import.meta.env.BASE_URL}settings/privacy-policy`}
                element={<Privacy />}
              />
              <Route
                path={`${import.meta.env.BASE_URL}settings/terms-&-services`}
                element={<Terms />}
              />
              <Route
                path={`${import.meta.env.BASE_URL}settings/faq`}
                element={<Faq />}
              />
              <Route
                path={`${import.meta.env.BASE_URL}settings/contact-us`}
                element={<Contact />}
              />
              <Route
                path={`${import.meta.env.BASE_URL}on-boarding/create`}
                element={<CreateOnBoarding />}
              />
              <Route
                path={`${import.meta.env.BASE_URL}on-boarding/update/:id`}
                element={<CreateOnBoarding />}
              />
              <Route
                path={`${import.meta.env.BASE_URL}on-boarding/manage`}
                element={<OnBoarding />}
              />
              <Route
                path={`${import.meta.env.BASE_URL}assistant/create`}
                element={<Create />}
              />
              <Route
                path={`${import.meta.env.BASE_URL}assistant/update/:id`}
                element={<Create />}
              />
              <Route
                path={`${import.meta.env.BASE_URL}assistant/manage`}
                element={<List />}
              />
              <Route
                path={`${import.meta.env.BASE_URL}prompt`}
                element={<Prompt />}
              />
              <Route
                index
                path={`${import.meta.env.BASE_URL}memberships/plans`}
                element={<ListMembership />}
              />
              <Route
                index
                path={`${import.meta.env.BASE_URL}memberships/create`}
                element={<CreateMembership />}
              />
              <Route
                index
                path={`${import.meta.env.BASE_URL}memberships/update/:id`}
                element={<CreateMembership />}
              />
              <Route
                index
                path={`${import.meta.env.BASE_URL}memberships/duration`}
                element={<MembershipTime />}
              />
            </Route>
            <Route
              path={`/dashboard/login`}
              element={
                <AuthLayout authentication={false}>
                  <Login />
                </AuthLayout>
              }
            />
          </Routes>
        </React.Suspense>
      </BrowserRouter>
    </React.Fragment>
  </Provider>
);
