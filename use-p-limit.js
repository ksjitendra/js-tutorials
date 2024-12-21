
const pLimit = require('p-limit');

// Creating dummy tasks
const asyncTask = async (id, shouldFail = false) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      if (shouldFail) {
        reject(`Task ${id} failed.`);
      } else {
        resolve(`Task ${id} completed.`);
      }
    }, Math.random() * 1000);
  });
};


//Executing the promises with using limit function
const pLimitExample = async () => {
  // Limit concurrency to 2 tasks at a time
  const limit = pLimit(2); 

 // creating 5 taks by using Array.from funcition  
  const tasks = Array.from({ length: 5 }, (_, i) => {
    return limit(() => asyncTask(i + 1, i === 2)); // making third taks fail
  });

  try {
    const results = await Promise.allSettled(tasks);
    console.log("p-limit results:", results);
  } catch (error) {
    console.error("p-limit error:", error);
  }
};

const runExample = async () => {

    try {
        await pLimitExample();
    } catch (error) {
        console.log('Getting trouble in executing pLimit', error);
        
    }

};

runExample()





