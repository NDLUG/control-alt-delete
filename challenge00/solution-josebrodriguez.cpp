// solution-josebrodriguez.cpp

// Created by: Jose Rodriguez


#include <sstream>
#include <vector>
#include <string>
#include <iostream>

class CountDrinks {
public:
    int min_drinks(std::vector<int>& nums) {
        std::vector<int> data{0};
        for (int i = 0; i < nums.size(); ++i) {
            if (i + nums[i] >= data.size()) {
                for (int j = data.size(); j <= i + nums[i]; ++j) {
                    data.push_back(data[i] + 1);
                }
            }
            if (data.size() >= nums.size()) {
                break;
            }
        }
        return data[nums.size() - 1] + 1;
    }

    int max_pos(std::vector<int>& nums){
        int max_pos = 0;
        for (int i = 0; i < nums.size(); ++i){
            if(nums[i] > nums[max_pos]){
                max_pos = i;
            }
        }
        return max_pos;
    }

    int min_drinks_rearranged(std::vector<int>& nums, int max_index){
        std::vector<int> new_vec;
        new_vec.push_back(nums[max_index]);
        for (int i = 0; i < nums.size(); ++i){
            if (i != max_index){
                new_vec.push_back(nums[i]);
            }
            
        }

        CountDrinks self;    
        return self.min_drinks(new_vec);
    }
};


int main()
{
    std::vector<int> vec;
    std::string buffer;
    int data;
    std::getline(std::cin, buffer);
    std::istringstream iss(buffer);

    while (iss >> data) vec.push_back(data);

    CountDrinks find;
    std::cout << "Part A: " << find.min_drinks(vec) << std::endl;
    std::cout << "Part B: " << find.min_drinks_rearranged(vec,find.max_pos(vec)) << std::endl;
    
}
