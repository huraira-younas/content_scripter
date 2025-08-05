import loader from '../../../assets/images/media/loader.svg';
const Loader = () => {

    return (
        <div id="loader">
            <img src={loader} className="loader-img" alt="Loader" />
        </div>
    );
};

export default Loader;
