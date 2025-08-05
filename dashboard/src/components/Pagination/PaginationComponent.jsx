import { Pagination } from "react-bootstrap";

const PaginationComponent = ({ pageNumber, setPageNumber, totalCount }) => {
  const pageCount = Math.ceil(totalCount);

  // Determine the page numbers to display
  const getPageNumbers = () => {
    const pages = [];
    const maxVisiblePages = 3;

    // Always show the first page
    pages.push(1);

    if (pageNumber > maxVisiblePages) {
      pages.push("...");
    }

    const startPage = Math.max(2, pageNumber - 1);
    const endPage = Math.min(pageCount - 1, pageNumber + 1);

    for (let i = startPage; i <= endPage; i++) {
      pages.push(i);
    }

    if (pageNumber < pageCount - (maxVisiblePages - 1)) {
      pages.push("...");
    }

    if (pageCount > 1) {
      pages.push(pageCount);
    }

    return pages;
  };

  const pageNumbers = getPageNumbers();

  return (
    <div className="d-flex justify-content-center mt-5">
      <Pagination>
        <Pagination.Prev
          className="shadow rounded-5"
          disabled={pageNumber === 1}
          onClick={() => pageNumber > 1 && setPageNumber(pageNumber - 1)}
        />
        {pageNumbers.map((item, index) => (
          <Pagination.Item
            key={`${index + 1}-page`}
            className="shadow rounded-5"
            active={item === pageNumber}
            onClick={() => item !== "..." && setPageNumber(item)}
            disabled={item === "..."}
          >
            {item}
          </Pagination.Item>
        ))}
        <Pagination.Next
          className="shadow rounded-5"
          disabled={pageNumber === pageCount}
          onClick={() =>
            pageNumber < pageCount && setPageNumber(pageNumber + 1)
          }
        />
      </Pagination>
    </div>
  );
};

export default PaginationComponent;
