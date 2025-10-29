import React, { Children } from "react";
import { Navigate, Outlet } from "react-router-dom";

const AdminRoute = ({ children }) => {
    const userRole =  localStorage.getItem('userRole');
    if (!userRole || userRole !== 'admin'){
        return <Navigate to='/' replace />;
    }
    return children ? children : <Outlet />;
}
export default AdminRoute;